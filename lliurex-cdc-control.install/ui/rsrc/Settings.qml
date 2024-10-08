import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.plasma.components as PC

Rectangle{
    color:"transparent"
    Text{ 
        text:i18nd("lliurex-cdc-control","Integration with ID")
        font.family: "Quattrocento Sans Bold"
        font.pointSize: 16
    }

    GridLayout{
        id:generalLayout
        rows:2
        flow: GridLayout.TopToBottom
        rowSpacing:10
        Layout.fillWidth: true
        anchors.left:parent.left

        Kirigami.InlineMessage {
            id: messageLabel
            visible:cdcControlBridge.showSettingsMessage[0]
            text:getMessageText(cdcControlBridge.showSettingsMessage[1])
            type:getMessageType(cdcControlBridge.showSettingsMessage[2])
            Layout.minimumWidth:490
            Layout.maximumWidth:490
            Layout.topMargin: 40
        }

        GridLayout{
            id: optionsGrid
            rows: 1
            flow: GridLayout.TopToBottom
            rowSpacing:5
            Layout.topMargin: messageLabel.visible?0:50

            PC.CheckBox {
                id:cdcControlCb
                text:i18nd("lliurex-cdc-control","Activate ID integration on this computer")
                checked:cdcControlBridge.isIntegrationCDCEnabled
                font.pointSize: 10
                focusPolicy: Qt.NoFocus
                Keys.onReturnPressed: cdcControlCb.toggled()
                Keys.onEnterPressed: cdcControlCb.toggled()
                onToggled:{
                   cdcControlBridge.manageChanges(checked)
                }

                Layout.alignment:Qt.AlignLeft
                Layout.bottomMargin:15
            }
        }
    }
    RowLayout{
        id:btnBox
        anchors.bottom: parent.bottom
        anchors.right:parent.right
        anchors.bottomMargin:15
        anchors.rightMargin:10
        spacing:10

        PC.Button {
            id:applyBtn
            visible:true
            focus:true
            display:AbstractButton.TextBesideIcon
            icon.name:"dialog-ok"
            text:i18nd("lliurex-cdc-control","Apply")
            Layout.preferredHeight:40
            enabled:cdcControlBridge.settingsChanged
            Keys.onReturnPressed: applyBtn.clicked()
            Keys.onEnterPressed: applyBtn.clicked()
            onClicked:{
                applyChanges()
                closeTimer.stop()
                cdcControlBridge.applyChanges()
            }
        }
        PC.Button {
            id:cancelBtn
            visible:true
            focus:true
            display:AbstractButton.TextBesideIcon
            icon.name:"dialog-cancel"
            text:i18nd("lliurex-cdc-control","Cancel")
            Layout.preferredHeight: 40
            enabled:cdcControlBridge.settingsChanged
            Keys.onReturnPressed: cancelBtn.clicked()
            Keys.onEnterPressed: cancelBtn.clicked()
            onClicked:{
                discardChanges()
                closeTimer.stop()
                cdcControlBridge.cancelChanges()
            }
        }
    } 

    ChangesDialog{
        id:cdcChangesDialog
        dialogTitle:"Lliurex ID Control"+" - "+i18nd("lliurex-cdc-control","Settings")
        dialogVisible:cdcControlBridge.showChangesDialog
	dialogMsg:i18nd("lliurex-cdc-control","The are pending changes to apply.\nDo you want apply the changes or discard them?")

        Connections{
            target:cdcChangesDialog
            function onDialogApplyClicked(){
                applyChanges()
                
            }
            function onDiscardDialogClicked(){
                discardChanges()
            }
            function onCancelDialogClicked(){
                closeTimer.stop()
                cdcControlBridge.manageSettingsDialog("Cancel")
            }

        }
    }
    CustomPopup{
        id:synchronizePopup
     }

    Timer{
        id:delayTimer
    }

    function delay(delayTime,cb){
        delayTimer.interval=delayTime;
        delayTimer.repeat=true;
        delayTimer.triggered.connect(cb);
        delayTimer.start()
    }

    Timer{
        id:waitTimer
    }

    function wait(delayTime,cb){
        waitTimer.interval=delayTime;
        waitTimer.repeat=true;
        waitTimer.triggered.connect(cb);
        waitTimer.start()
    }


    function getMessageText(code){

        var msg="";
        switch (code){
            case 0:
                msg=i18nd("lliurex-cdc-control","Changes saved. You need to restart your computer");
                break;
            case -1:
                msg=i18nd("lliurex-cdc-control","Unable to activate integration with ID");
                break;
            case -2:
                msg=i18nd("lliurex-cdc-control","Unable to disable integration with ID");
                break;
            default:
                break;
        }
        return msg;

    }

    function getMessageType(type){

        switch (type){
            case "Info":
                return Kirigami.MessageType.Information
            case "Success":
                return Kirigami.MessageType.Positive
            case "Error":
                return Kirigami.MessageType.Error
        }

    } 

    function applyChanges(){
        synchronizePopup.open()
        synchronizePopup.popupMessage=i18nd("lliurex-cdc-control", "Apply changes. Wait a moment...")
        delayTimer.stop()
        delay(500, function() {
            if (cdcControlBridge.closePopUp){
                synchronizePopup.close(),
                delayTimer.stop()
            }
        })
    } 

    function discardChanges(){
        synchronizePopup.open()
        synchronizePopup.popupMessage=i18nd("lliurex-cdc-control", "Restoring previous values. Wait a moment...")
        delayTimer.stop()
        delay(1000, function() {
            if (cdcControlBridge.closePopUp){
                synchronizePopup.close(),
                delayTimer.stop()

            }
        })
    }  
} 
