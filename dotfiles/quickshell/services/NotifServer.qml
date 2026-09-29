pragma Singleton
import Quickshell.Services.Notifications

NotificationServer {
    id: server

    bodySupported: true
    actionsSupported: true
    imageSupported: true
    persistenceSupported: true

    onNotification: notification => {
        notification.tracked = true;
    }
}
