<?php
/*
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC. All rights reserved.                        |
 |                                                                    |
 | This work is published under the GNU AGPLv3 license with some      |
 | permitted exceptions and without any warranty. For full license    |
 | and copyright information, see https://civicrm.org/licensing       |
 +--------------------------------------------------------------------+
 */

/**
 *
 * @package CRM
 * @copyright CiviCRM LLC https://civicrm.org/licensing
 */

/**
 * This class generates form components for processing a survey.
 */
class CRM_Campaign_Form_Survey extends CRM_Core_Form {

  /**
   * The id of the object being edited.
   *
   * @var int
   */
  protected $_surveyId;

  /**
   * Action.
   *
   * @var int
   */
  public $_action;

  /**
   * SurveyTitle.
   *
   * @var string
   */
  protected $_surveyTitle;

  /**
   * Explicitly declare the entity api name.
   */
  public function getDefaultEntity() {
    return 'Survey';
  }

  /**
   * Get the entity id being edited.
   *
   * @return int|null
   */
  public function getEntityId() {
    return $this->_surveyId;
  }

  public function preProcess() {
    // Multistep form doesn't play well with popups
    $this->preventAjaxSubmit();

    if (!CRM_Campaign_BAO_Campaign::accessCampaign()) {
      CRM_Utils_System::permissionDenied();
    }

    $this->_action = CRM_Utils_Request::retrieve('action', 'String', $this, FALSE, 'add', 'REQUEST');
    $this->_surveyId = CRM_Utils_Request::retrieve('id', 'Positive', $this, FALSE);

    if ($this->_surveyId) {
      $this->_single = TRUE;

      $params = ['id' => $this->_surveyId];
      CRM_Campaign_BAO_Survey::retrieve($params, $surveyInfo);
      $this->_surveyTitle = $surveyInfo['title'];
      $this->assign('surveyTitle', $this->_surveyTitle);
      $this->setTitle(ts('Configure Survey - %1', [1 => $this->_surveyTitle]));
    }

    $this->assign('action', $this->_action);
    $this->assign('surveyId', $this->_surveyId);

    // Add custom data to form
    CRM_Custom_Form_CustomData::addToForm($this);

    // CRM-11480, CRM-11682
    // Preload libraries required by the "Questions" tab
    CRM_UF_Page_ProfileEditor::registerProfileScripts();
    CRM_UF_Page_ProfileEditor::registerSchemas(['IndividualModel', 'ActivityModel']);

    CRM_Campaign_Form_Survey_TabHeader::build($this);
  }

  /**
   * Build the form object.
   */
  public function buildQuickForm() {
    $session = CRM_Core_Session::singleton();
    if ($this->_surveyId) {
      $buttons = [
        [
          'type' => 'upload',
          'name' => ts('Save'),
          'isDefault' => TRUE,
        ],
        [
          'type' => 'upload',
          'name' => ts('Save and Done'),
          'subName' => 'done',
        ],
        [
          'type' => 'upload',
          'name' => ts('Save and Next'),
          'spacing' => '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
          'subName' => 'next',
        ],
      ];
    }
    else {
      $buttons = [
        [
          'type' => 'upload',
          'name' => ts('Continue'),
          'spacing' => '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
          'isDefault' => TRUE,
        ],
      ];
    }
    $buttons[] = [
      'type' => 'cancel',
      'name' => ts('Cancel'),
    ];
    $this->addButtons($buttons);

    $url = CRM_Utils_System::url('civicrm/campaign', 'reset=1&subPage=survey');
    $session->replaceUserContext($url);
  }

  public function endPostProcess() {
    // make submit buttons keep the current working tab opened.
    if ($this->_action & (CRM_Core_Action::UPDATE | CRM_Core_Action::ADD)) {
      $tabTitle = $className = CRM_Utils_String::getClassName($this->_name);
      if ($tabTitle == 'Main') {
        $tabTitle = 'Main settings';
      }
      $subPage = strtolower($className);
      CRM_Core_Session::setStatus(ts("'%1' have been saved.", [1 => $tabTitle]), ts('Saved'), 'success');

      $this->postProcessHook();

      if ($this->_action & CRM_Core_Action::ADD) {
        CRM_Utils_System::redirect(CRM_Utils_System::url("civicrm/survey/configure/questions",
          "action=update&reset=1&id={$this->_surveyId}"));
      }
      if ($this->controller->getButtonName('submit') == "_qf_{$className}_upload_done") {
        CRM_Utils_System::redirect(CRM_Utils_System::url('civicrm/campaign', 'reset=1&subPage=survey'));
      }
      elseif ($this->controller->getButtonName('submit') == "_qf_{$className}_upload_next") {
        $subPage = CRM_Campaign_Form_Survey_TabHeader::getNextTab($this);
        CRM_Utils_System::redirect(CRM_Utils_System::url("civicrm/survey/configure/{$subPage}",
          "action=update&reset=1&id={$this->_surveyId}"));
      }
      else {
        CRM_Utils_System::redirect(CRM_Utils_System::url("civicrm/survey/configure/{$subPage}",
          "action=update&reset=1&id={$this->_surveyId}"));
      }
    }
  }

  /**
   * @return string
   */
  public function getTemplateFileName(): string {
    if ($this->_surveyId <= 0 || $this->controller->getPrint()) {
      return parent::getTemplateFileName();
    }
    // hack lets suppress the form rendering for now
    self::$_template->assign('isForm', FALSE);
    return 'CRM/Campaign/Form/Survey/Tab.tpl';
  }

}
