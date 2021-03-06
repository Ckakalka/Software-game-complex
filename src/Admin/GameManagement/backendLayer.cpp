#include "backendLayer.h"

#include <qdebug.h>
#include <utility>

CheckableTheme::CheckableTheme()
	: _numberOfEasyQuestions(-1), _numberOfMediumQuestions(-1), _numberOfHardQuestions(-1) {};
CheckableTheme::CheckableTheme(QString title, qint32 easy, qint32 medium, qint32 hard)
	: _title(std::move(title)), _numberOfEasyQuestions(easy), _numberOfMediumQuestions(medium),
	  _numberOfHardQuestions(hard) {};
// CheckableTheme &CheckableTheme::operator=(const CheckableTheme &theme) {
//	this->_title				   = theme._title;
//	this->_numberOfEasyQuestions   = theme._numberOfEasyQuestions;
//	this->_numberOfMediumQuestions = theme._numberOfMediumQuestions;
//	this->_numberOfHardQuestions   = theme._numberOfHardQuestions;
//	return *this;
// }


CheckableTheme::CheckableTheme(const CheckableTheme &theme)
	: CheckableTheme(theme._title, theme._numberOfEasyQuestions, theme._numberOfMediumQuestions,
					 theme._numberOfHardQuestions) {}

SessionSettings::SessionSettings()
	: title(), checkableThemes(), satisfactoryNumberOfCorrectAnswers(-1), goodNumberOfCorrectAnswers(-1),
	  excellentNumberOfCorrectAnswers(-1), testTime(-1),
	  situationDifficulty(static_cast<int>(SituationDifficulty::UNDEFINED)), gameTime(-1) {};

void SessionSettings::setSettings(QString title, qint32 satisfactory, qint32 good, qint32 excellent, qint32 testTime,
								  qint32 situationDifficulty, qint32 gameTime) {
	this->title = std::move(title);
	this->satisfactoryNumberOfCorrectAnswers = satisfactory;
	this->goodNumberOfCorrectAnswers		 = good;
	this->excellentNumberOfCorrectAnswers	 = excellent;
	this->testTime							 = testTime;
	this->situationDifficulty				 = situationDifficulty;
	this->gameTime							 = gameTime;
	qDebug() << "title " << this->title;
	qDebug() << "satisfactory " << this->satisfactoryNumberOfCorrectAnswers;
	qDebug() << "good " << this->goodNumberOfCorrectAnswers;
	qDebug() << "excellent " << this->excellentNumberOfCorrectAnswers;
	qDebug() << "testTime" << this->testTime;
	qDebug() << "difficulty" << this->situationDifficulty;
	qDebug() << "gameTime" << this->gameTime;
}

void SessionSettings::addTheme(QString themeTitle, qint32 easy, qint32 medium, qint32 hard) {
	checkableThemes.push_back(CheckableTheme(std::move(themeTitle), easy, medium, hard));
}

void SessionSettings::printThemes() {
	for (int i = 0; i < checkableThemes.count(); ++i) {
		qDebug() << "title " << checkableThemes[i]._title;
		qDebug() << "easy " << checkableThemes[i]._numberOfEasyQuestions;
		qDebug() << "medium " << checkableThemes[i]._numberOfMediumQuestions;
		qDebug() << "hard " << checkableThemes[i]._numberOfHardQuestions;
		qDebug();
	}
}