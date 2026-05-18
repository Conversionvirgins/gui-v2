/*
** AI Energy Assistant
** Ask questions about your energy system.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	VeQuickItem {
		id: aiResponse
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/AiResponse"
	}
	VeQuickItem {
		id: aiStatus
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/AiStatus"
	}
	VeQuickItem {
		id: aiQuestion
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/AiQuestion"
	}

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "AI Energy Assistant"
			}

			ListTextField {
				text: "Ask a question"
				placeholderText: "e.g. Should I charge now?"
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/AiQuestion"
			}

			ListText {
				text: "You asked"
				secondaryText: aiQuestion.valid && aiQuestion.value !== ""
					? aiQuestion.value
					: "Type above or use quick questions"
			}

			SettingsListHeader {
				text: "Response"
			}

			ListText {
				text: "AI says"
				secondaryText: aiResponse.valid && aiResponse.value !== ""
					? aiResponse.value
					: "Ask me anything about your energy system!"
			}

			ListText {
				text: "Status"
				secondaryText: {
					if (!aiStatus.valid) return "Ready"
					if (aiStatus.value === "thinking") return "Thinking..."
					if (aiStatus.value === "done") return "Ready"
					if (aiStatus.value === "error") return "Error - try again"
					return "Ready"
				}
			}

			SettingsListHeader {
				text: "Quick Questions"
			}

			ListButton {
				text: "Should I charge now?"
				secondaryText: "Ask"
				onClicked: aiQuestion.setValue("Should I charge my battery now based on the current Agile price?")
			}

			ListButton {
				text: "How's my solar doing?"
				secondaryText: "Ask"
				onClicked: aiQuestion.setValue("How is my solar performing right now? Is it a good day for solar?")
			}

			ListButton {
				text: "Battery health check"
				secondaryText: "Ask"
				onClicked: aiQuestion.setValue("How does my battery look? Check the voltage, temperature and state of charge.")
			}

			ListButton {
				text: "Energy saving tips"
				secondaryText: "Ask"
				onClicked: aiQuestion.setValue("Based on my current energy usage and Agile prices, what tips do you have to save money?")
			}

			SettingsListHeader {
				text: "Powered by OpenRouter AI | GPT-4o Mini"
			}
		}
	}
}
