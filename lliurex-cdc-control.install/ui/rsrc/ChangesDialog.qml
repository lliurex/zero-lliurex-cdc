import QtQuick 2.6      
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3
//import org.kde.plasma.components 3.0 as PC3


Dialog {
    id: customDialog
    property alias dialogTitle:customDialog.title
    property alias dialogVisible:customDialog.visible
    property alias dialogMsg:dialogText.text
    signal dialogApplyClicked
    signal discardDialogClicked
    signal cancelDialogClicked
    property bool xButton

    visible:dialogVisible
    title:dialogTitle
    modality:Qt.WindowModal

    onVisibleChanged:{
        if (!this.visible && xButton){
            if (cdcControlBridge.showChangesDialog){
                cancelDialogClicked()
            }
        }else{
            xButton=true
        }
    }

    contentItem: Rectangle {
        color: "#ebeced"
        implicitWidth: 400
        implicitHeight: 105
        anchors.topMargin:5
        anchors.leftMargin:5

        Image{
            id:dialogIcon
            source:"/usr/share/icons/breeze/status/64/dialog-warning.svg"

        }
        
        Text {
            id:dialogText
            text:dialogMsg
            font.family: "Quattrocento Sans Bold"
            font.pointSize: 10
            anchors.left:dialogIcon.right
            anchors.verticalCenter:dialogIcon.verticalCenter
            anchors.leftMargin:10
        
        }
      
        //PC3.Button {
        Button{
            id:dialogApplyBtn
            display:AbstractButton.TextBesideIcon
            //icon.name:"dialog-ok"
            icon.source:"/usr/share/icons/breeze/actions/22/dialog-ok"
	   //text: i18nd("lliurex-cdc-control","Apply")
            text:"Apply"
            focus:true
            font.family: "Quattrocento Sans Bold"
            font.pointSize: 10
            anchors.bottom:parent.bottom
            anchors.right:dialogDiscardBtn.left
            anchors.rightMargin:10
            anchors.bottomMargin:5
            DialogButtonBox.buttonRole: DialogButtonBox.ApplyRole
            Keys.onReturnPressed: dialogApplyBtn.clicked()
            Keys.onEnterPressed: dialogApplyBtn.clicked()
            onClicked:{
                xButton=false
                dialogApplyClicked()
                cdcControlBridge.manageSettingsDialog("Accept")
            }
        }

        //PC3.Button {
        Button{
            id:dialogDiscardBtn
            display:AbstractButton.TextBesideIcon
            //icon.name:"delete"
            icon.source:"/usr/share/icons/breeze/actions/22/delete"
	    //text: i18nd("lliurex-cdc-control","Discard")
            text:"Discard"
            focus:true
            font.family: "Quattrocento Sans Bold"
            font.pointSize: 10
            anchors.bottom:parent.bottom
            anchors.right:dialogCancelBtn.left
            anchors.rightMargin:10
            anchors.bottomMargin:5
            DialogButtonBox.buttonRole: DialogButtonBox.DestructiveRole
            Keys.onReturnPressed: dialogDiscardBtn.clicked()
            Keys.onEnterPressed: dialogDiscardBtn.clicked()
            onClicked:{
                xButton=false
                discardDialogClicked(),
                cdcControlBridge.manageSettingsDialog("Discard")
            }
        }

        //PC3.Button {
        Button{
            id:dialogCancelBtn
            display:AbstractButton.TextBesideIcon
            //icon.name:"dialog-cancel"
	    icon.source:"/usr/share/icons/breeze/actions/22/dialog-cancel"
            //text: i18nd("lliurex-cdc-control","Cancel")
            text: "Cancel"
            focus:true
            font.family: "Quattrocento Sans Bold"
            font.pointSize: 10
            anchors.bottom:parent.bottom
            anchors.right:parent.right
            anchors.rightMargin:5
            anchors.bottomMargin:5
            DialogButtonBox.buttonRole:DialogButtonBox.RejectRole
            Keys.onReturnPressed: dialogCancelBtn.clicked()
            Keys.onEnterPressed: dialogCancelBtn.clicked()
            onClicked:{
                xButton:false
                cancelDialogClicked()
            }
        }
    }
 }
