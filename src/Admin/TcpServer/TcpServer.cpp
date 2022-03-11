#include "TcpServer.hpp"

TcpServer::TcpServer(QObject* parent) : QObject(parent) {
    connect(&_server, &QTcpServer::newConnection, this, &TcpServer::onNewConnection);
    connect(this, &TcpServer::newMessage, this, &TcpServer::onNewMessage);
//    database.connectToDataBase();
}

void TcpServer::sendMessage(const QString &message) { emit newMessage("Server: " + message.toUtf8()); }

void TcpServer::onNewConnection() {
    const auto client = _server.nextPendingConnection();
    if (client == nullptr) {
        return;
    }

    qInfo() << "New client connected.";

    _clients.insert(this->getClientKey(client), client);

    connect(client, &QTcpSocket::readyRead, this, &TcpServer::onReadyRead);
    connect(client, &QTcpSocket::disconnected, this, &TcpServer::onClientDisconnected);
}

void TcpServer::onReadyRead() {
    const auto client = qobject_cast<QTcpSocket*>(sender());

    if (client == nullptr) {
        return;
    }

    QByteArray request = client->readAll();
    QList<QByteArray> data = request.split(';');
    if (!data.empty()) {
        qInfo() << "user# " + this->getClientKey(client).toUtf8();
        qInfo() << "type = " + data[0];
        for (int i = 1; i < data.size(); i++)
            qInfo() << "  + " + data[i];

        if (data[0] == "0") {
            QVariantList row;
            row.append(data[1]);
            row.append(data[2]);
//            database.insertIntoTotalReportTable(row);
        }
    }

    const auto message = this->getClientKey(client).toUtf8() + ": " + request;

    emit newMessage(message);
}

void TcpServer::onClientDisconnected() {
    const auto client = qobject_cast<QTcpSocket*>(sender());

    if (client == nullptr) {
        return;
    }

    _clients.remove(this->getClientKey(client));
}

void TcpServer::onNewMessage(const QByteArray &ba) {
    qInfo() << ba;
    for (const auto &client: qAsConst(_clients)) {
        client->write(ba);
        client->flush();
    }
}

QString TcpServer::getClientKey(const QTcpSocket* client) const {
    return client->peerAddress().toString().append(":").append(QString::number(client->peerPort()));
}

void TcpServer::onStart() {
    if (_server.listen(QHostAddress::Any, 45000)) {
        qInfo() << "Listening ...";
        _isServerAvailable = true;
    }
}

void TcpServer::onStop() {
    qInfo() << "Stop listening";
    _server.close();
    for (auto client: qAsConst(_clients)) {
        //		qInfo() << this->getClientKey(client).toUtf8();
        client->deleteLater();
    }
    _isServerAvailable = false;
}

bool TcpServer::isServerAvailable() { return _isServerAvailable; }