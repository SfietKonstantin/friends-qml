/*
 * Copyright (C) 2013 Lucien XU <sfietkonstantin@free.fr>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * "Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * The names of its contributors may not be used to endorse or promote 
 *     products derived from this software without specific prior written 
 *     permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 */ 

#include "pagepixmapprovider.h"
#include <QtOpenGL/QGLWidget>
#include <QtCore/QDebug>

PagePixmapProvider::PagePixmapProvider(WIDGET *window):
    QDeclarativeImageProvider(QDeclarativeImageProvider::Image)
{
    m_window = window;
}

QImage PagePixmapProvider::requestImage(const QString &id, QSize *size,
                                          const QSize &requestedSize)
{
    if (requestedSize.isValid()) {
        // We don't return requested size
        QImage image (requestedSize.width(), requestedSize.height(), QImage::Format_RGB888);
        image.fill(Qt::black);
        size->setWidth(requestedSize.width());
        size->setHeight(requestedSize.height());
        return image;
    }

    // id should be "screenshot"
    if (id != "screenshotportrait" && id != "screenshotlandscape") {
        size->setWidth(0);
        size->setHeight(0);
        return QImage();
    }

#ifdef MEEGO_EDITION_HARMATTAN
    QImage image = m_window->grabFrameBuffer();
    if (id == "screenshotportrait") {
        QTransform transform;
        transform.rotate(90);
        image = image.transformed(transform);
    }
#else
    QImage image = QPixmap::grabWindow(m_window->winId()).toImage();
#endif
    size->setWidth(image.width());
    size->setHeight(image.height());

    return image;
}
