//import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.kirigami 2.6 as Kirigami
import QtQuick 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.12
import QtQuick.Window 2.2

ApplicationWindow {

    property bool closing: false
    id:mainWindow
    visible: true
    title: "LliureX ID Control"
    color:"#eff0f1"
    property int margin: 1
    width: mainLayout.implicitWidth + 2 * margin
    height: mainLayout.implicitHeight + 2 * margin
    minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
    minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin
    maximumWidth: mainLayout.Layout.maximumWidth + 2 * margin
    maximumHeight: mainLayout.Layout.maximumHeight + 2 * margin
    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 0.5
    }

    
    onClosing: {
        close.accepted=closing;
        cdcControlBridge.closeApplication()
        delay(100, function() {
            if (cdcControlBridge.closeGui){
                closing=true,
                closeTimer.stop(),           
                mainWindow.close();

            }else{
                closing=false;
            }
        })
        
    }
    
    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: margin
        Layout.minimumWidth:670
        Layout.maximumWidth:670
        Layout.minimumHeight:350
        Layout.maximumHeight:350

        RowLayout {
            id: bannerBox
            Layout.alignment:Qt.AlignTop
            Layout.minimumHeight:120
            Layout.maximumHeight:120

            Image{
                id:banner
                source: "/usr/share/lliurex-cdc-control/rsrc/banner.png"
            }
        }

        StackView {
            id: mainView
            property int currentIndex:cdcControlBridge.currentStack
            implicitWidth: 670
            Layout.alignment:Qt.AlignHCenter
            Layout.leftMargin:0
            Layout.fillWidth:true
            Layout.fillHeight: true
            initialItem:loadingView

            onCurrentIndexChanged:{
                switch (currentIndex){
                    case 0:
                        mainView.replace(loadingView)
                        break;
                    case 1:
                        mainView.replace(applicationOptionsView)
                }
            }

            replaceEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 600
                }
            }
            replaceExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 600
                }
            }

            Component{
                id:loadingView
                Loading{
                    id:loading
                }
            }
            Component{
                id:applicationOptionsView
                ApplicationOptions{
                    id:applicationOptions
                }
            }

        }

    }

    Timer{
        id:closeTimer
    }

    function delay(delayTime,cb){
        closeTimer.interval=delayTime;
        closeTimer.repeat=true;
        closeTimer.triggered.connect(cb);
        closeTimer.start()
    }


}

