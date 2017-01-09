using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Csla.Web;
using CambridgeSoft.COE.RegistrationAdmin.Services;
using PerkinElmer.COE.Registration.Server.Forms.RegistrationAdmin.UserControls;
using Resources;
using CambridgeSoft.COE.Framework.GUIShell;
using System.Reflection;
using CambridgeSoft.COE.Framework.ExceptionHandling;

namespace PerkinElmer.COE.Registration.Server.Forms.RegistrationAdmin.ContentArea
{
    public partial class BatchComponent : GUIShellPage
    {

        #region Variables
        RegistrationMaster _masterPage = null;
        CslaDataSource _batchComponentPropertyDatasource = new CslaDataSource();
        #endregion

        #region Properties
        private ConfigurationRegistryRecord ConfigurationRegistryRecord {
            get {
                return (ConfigurationRegistryRecord) Session["ConfigurationRegistryRecord"];
            }
            set {
                Session["ConfigurationRegistryRecord"] = value;
            }
        }
        #endregion

        #region Page Load

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                PropertyList1.CurrentPage = CourrentPageEnum.BatchComponent;
                //PropertyList1.DataSourceID = _batchComponentPropertyDatasource.ID;
                this.DataBind();
                SetControlsAttributtes();
                if (this.PropertyList1.ConfigurationBO.SelectedPropertyList != ConfigurationRegistryRecord.PropertyListType.BatchComponent)
                {
                    this.PropertyList1.ConfigurationBO.SelectedPropertyList = ConfigurationRegistryRecord.PropertyListType.BatchComponent;
                }
            }
            catch (Exception exception)
            {
                COEExceptionDispatcher.HandleUIException(exception);
                _masterPage.DisplayErrorMessage(exception, false);
            }
	
        }

        #endregion     

        #region Methods
        protected override void OnInit(EventArgs e)
        {
            RegUtilities.WriteToRegLog(GUIShellTypes.LogMessageType.BeginMethod, MethodBase.GetCurrentMethod().Name);
            #region Page Settings

            // To make easier to read the source code.
            if(this.Master is RegistrationMaster)
            {
                _masterPage = (RegistrationMaster) this.Master;
                _masterPage.ShowLeftPanel = false;
            }

            #endregion
            base.OnInit(e);
            this.Controls.Add(_batchComponentPropertyDatasource);
            _batchComponentPropertyDatasource.ID = "BatchComponentPropertyDS";
            _batchComponentPropertyDatasource.TypeAssemblyName = "CambridgeSoft.COE.Registration.Services";
            _batchComponentPropertyDatasource.TypeName = "PropertyList";
            _batchComponentPropertyDatasource.SelectObject += new EventHandler<SelectObjectArgs>(BatchComponentPropertyDatasource_SelectObject);
            RegUtilities.WriteToRegLog(GUIShellTypes.LogMessageType.EndMethod, MethodBase.GetCurrentMethod().Name);
        }

        private void BatchComponentPropertyDatasource_SelectObject(object sender, SelectObjectArgs e)
        {
            if(this.ConfigurationRegistryRecord == null)
                this.ConfigurationRegistryRecord = ConfigurationRegistryRecord.NewConfigurationRegistryRecord();

            e.BusinessObject = this.ConfigurationRegistryRecord.BatchComponentList;
        }

        protected override void SetControlsAttributtes()
        {
            this.Page.Title = Resource.Brand + " - " + Resource.RegAdminHome_Page_Title + " - " + Resource.BatchCompProperties_Page_Title;
            //this.Btn_Revert.Text = Resource.Revert_Button_Text;
            //this.Btn_Save.Text = Resource.Save_Button_Text;
            //if (this.PropertyList1.ConfigurationBO.IsDirty)
            //    Btn_Revert.Enabled = true;
            //else
            //    Btn_Revert.Enabled = false;


            switch (this.PropertyList1.CurrentPage)
            {
                case CourrentPageEnum.PropertyList:
                    this.PropertiesPanel.SetSlectedTab(3);

                    break;
                case CourrentPageEnum.Batch:
                    this.PropertiesPanel.SetSlectedTab(0);

                    break;
                case CourrentPageEnum.BatchComponent:
                    this.PropertiesPanel.SetSlectedTab(1);

                    break;
                case CourrentPageEnum.Compound:
                    this.PropertiesPanel.SetSlectedTab(2);

                    break;
                case CourrentPageEnum.Structure:
                    this.PropertiesPanel.SetSlectedTab(4);

                    break;
            }

        }

        private void SaveConfigurationBO()
        {
            //this.ConfigurationRegistryRecord.CreateCoeFormTemplates();
            this.ConfigurationRegistryRecord = this.PropertyList1.ConfigurationBO.Save();
        }

        private void RevertConfigurationBO()
        {
            if(this.PropertyList1.ConfigurationBO.IsDirty)
                this.ConfigurationRegistryRecord = ConfigurationRegistryRecord.NewConfigurationRegistryRecord();
        }

        #endregion               

        #region Event Handlers

        //protected void Btn_Save_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        SaveConfigurationBO();
        //    }
        //    catch (Exception exception)
        //    {
        //        COEExceptionDispatcher.HandleUIException(exception);
        //        _masterPage.DisplayErrorMessage(exception, false);
        //    }
	
        //}

     

        //protected void Btn_Revert_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        this.RevertConfigurationBO();
        //    }
        //    catch (Exception exception)
        //    {
        //        COEExceptionDispatcher.HandleUIException(exception);
        //        _masterPage.DisplayErrorMessage(exception, false);
        //    }
	
        //}

        #endregion

    }
}
