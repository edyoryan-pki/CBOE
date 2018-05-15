﻿using System;
using System.IO;
using System.Net;
using System.Collections.Generic;
using System.Net.Http;
using System.Security;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Http;
using System.Xml;
using System.Linq;
using Resources;
using Microsoft.Web.Http;
using Newtonsoft.Json.Linq;
using Swashbuckle.Swagger.Annotations;
using CambridgeSoft.COE.ChemBioViz.Services.COEChemBioVizService;
using CambridgeSoft.COE.Framework;
using CambridgeSoft.COE.Framework.Caching;
using CambridgeSoft.COE.Framework.COEDataViewService;
using CambridgeSoft.COE.Framework.COEHitListService;
using CambridgeSoft.COE.Framework.COEPageControlSettingsService;
using CambridgeSoft.COE.Framework.COESearchCriteriaService;
using CambridgeSoft.COE.Framework.COESearchService;
using CambridgeSoft.COE.Framework.Common;
using CambridgeSoft.COE.RegistrationAdmin.Services;
using PerkinElmer.COE.Registration.Server.Code;
using PerkinElmer.COE.Registration.Server.Models;
using CambridgeSoft.COE.Framework.COEExportService;
using CambridgeSoft.COE.Framework.COEFormService;
using CambridgeSoft.COE.Framework.Controls.COEFormGenerator;
using CambridgeSoft.COE.Framework.Common.Messaging;
using CambridgeSoft.COE.Registration.Services;
using CambridgeSoft.COE.Registration.Services.BLL;

namespace PerkinElmer.COE.Registration.Server.Controllers
{
    [ApiVersion(Consts.apiVersion)]
    public class SearchController : RegControllerBase
    {
        public static QueryData GetHitlistQueryInternal(int id, bool? temp)
        {
            var hitlistBO = GetHitlistBO(id);
            if (hitlistBO.SearchCriteriaID == 0)
                throw new RegistrationException("The hit-list has no query associated with it");
            COESearchCriteriaBO searchCriteriaBO = COESearchCriteriaBO.Get(hitlistBO.SearchCriteriaType, hitlistBO.SearchCriteriaID);
            if (searchCriteriaBO.SearchCriteria == null)
                throw new RegistrationException("No search criteria is associated with this hit-list");
            var formGroup = GetFormGroup(temp);
            return new QueryData(searchCriteriaBO.DataViewId != formGroup.Id, searchCriteriaBO.SearchCriteria.ToString());
        }

        private JObject GetHitlistRecordsInternal(int id, bool? temp, int? skip = null, int? count = null, string sort = null, bool highlightSubStructures = false)
        {
            var hitlistBO = GetHitlistBO(id);
            return GetRegistryRecordsListView(temp, skip, count, sort, hitlistBO.HitListInfo, null, highlightSubStructures);
        }

        private string TrimtHitListName(string hitListName)
        {
            return hitListName.Substring(0, Math.Min(hitListName.Length, 50));
        }

        private int CreateTempHitlist(QueryData queryData, bool? temp)
        {
            var dataViewId = int.Parse(temp != null && temp.Value ? ControlIdChangeUtility.TEMPSEARCHGROUPID : ControlIdChangeUtility.PERMSEARCHGROUPID);
            var dataView = SearchFormGroupAdapter.GetDataView(dataViewId);
            string structureName;
            var searchCriteria = CreateSearchCriteria(queryData.SearchCriteria, out structureName);

            var hitlistInfo = CreateTempHitlist(dataView, searchCriteria, structureName);
            return hitlistInfo.HitListID;
        }

        private HitListInfo CreateTempHitlist(COEDataView dataView, SearchCriteria searchCriteria, string structureName = null)
        {
            var coeSearch = new COESearch();
            var hitlistInfo = coeSearch.GetHitList(searchCriteria, dataView);
            var hitlistBO = GetHitlistBO(hitlistInfo.HitListID);
            hitlistBO.SearchCriteriaID = searchCriteria.SearchCriteriaID;
            hitlistBO.Name = string.Format("Search {0}", hitlistInfo.HitListID);
            if (!string.IsNullOrEmpty(structureName))
            {
                var additionalCriteriaCount = searchCriteria.Items.Count - 1;
                var more = additionalCriteriaCount > 0 ? string.Format(" +{0}", additionalCriteriaCount) : string.Empty;
                var moreDesc = additionalCriteriaCount > 0 ? string.Format(" with {0} more criteria", additionalCriteriaCount) : string.Empty;
                var hitListDescription = string.Format("Search for {0}{1}", structureName, moreDesc);
                hitlistBO.Description = hitListDescription.Substring(0, Math.Min(hitListDescription.Length, 250));
            }
            hitlistBO.Update();
            return hitlistInfo;
        }

        private COEDataView AddMolWt(COEDataView dataView)
        {
            int basetableid = dataView.Basetable;
            COEDataView resultDataview = new COEDataView();
            resultDataview = GetDataViewClone(dataView);
            resultDataview.Tables = new COEDataView.DataViewTableList();
            COEDataView basetableDataview = new COEDataView();
            COEDataView childtableDataview = new COEDataView();
            foreach (COEDataView.DataViewTable coeTable in dataView.Tables)
            {
                if (coeTable.Id == basetableid)
                {
                    basetableDataview.Tables.Add(GetTableNode(coeTable));
                }
                else
                {
                    childtableDataview.Tables.Add(GetTableNode(coeTable));
                }
            }
            resultDataview.Tables.AddRange(basetableDataview.Tables);
            resultDataview.Tables.AddRange(childtableDataview.Tables);

            return resultDataview;
        }

        private COEDataView GetDataViewClone(COEDataView dataview)
        {
            COEDataView newDataview = new COEDataView();
            newDataview.Application = dataview.Application;
            newDataview.Basetable = dataview.Basetable;

            newDataview.Database = dataview.Database;
            newDataview.DataViewHandling = dataview.DataViewHandling;
            newDataview.DataViewID = dataview.DataViewID;
            newDataview.Description = dataview.Description;
            newDataview.Name = dataview.Name;
            newDataview.Relationships = dataview.Relationships;
            newDataview.Tables = dataview.Tables;
            newDataview.XmlNs = dataview.XmlNs;
            return newDataview;
        }

        private COEDataView.DataViewTable GetTableNode(COEDataView.DataViewTable coeTable)
        {
            COEDataView.DataViewTable newCoeTable = new COEDataView.DataViewTable();
            newCoeTable = GetDVTableNode(coeTable);
            newCoeTable.Fields = new COEDataView.DataViewFieldList();
            for (int i = 0; i < coeTable.Fields.Count; i++)
            {
                COEDataView.Field xnode = new COEDataView.Field();
                xnode = coeTable.Fields[i];
                newCoeTable.Fields.Add(xnode);

                // only add the mw and mf virtual columns if we have reason to believe that this is a structure column
                if ((coeTable.Fields[i].IndexType == COEDataView.IndexTypes.CS_CARTRIDGE) ||
                        (coeTable.Fields[i].MimeType == COEDataView.MimeTypes.CHEMICAL_X_CDX))
                {
                    newCoeTable.Fields.Add(GetFieldNode(xnode, "Mol Wt"));
                    newCoeTable.Fields.Add(GetFieldNode(xnode, "Mol Formula"));
                }
            }

            return newCoeTable;
        }

        private COEDataView.Field GetFieldNode(COEDataView.Field node, string alias)
        {
            COEDataView.Field newnode = new COEDataView.Field();
            newnode.Alias = alias;
            newnode.DataType = node.DataType;
            newnode.Id = node.Id;
            newnode.IndexType = node.IndexType;
            newnode.LookupDisplayFieldId = node.LookupDisplayFieldId;
            newnode.LookupFieldId = node.LookupFieldId;
            newnode.LookupSortOrder = node.LookupSortOrder;
            newnode.MimeType = node.MimeType;
            newnode.Name = node.Name;
            newnode.ParentTableId = node.ParentTableId;
            newnode.SortOrder = node.SortOrder;
            return newnode;
        }

        private COEDataView.DataViewTable GetDVTableNode(COEDataView.DataViewTable node)
        {
            COEDataView.DataViewTable newnode = new COEDataView.DataViewTable();
            newnode.Alias = node.Alias;
            newnode.Database = node.Database;
            newnode.Fields = node.Fields;
            newnode.Id = node.Id;
            newnode.IsView = node.IsView;
            newnode.Name = node.Name;
            newnode.PrimaryKey = node.PrimaryKey;

            return newnode;
        }

        private JArray GetExportTemplates(int dataViewId)
        {
            var exportTemplate = new JArray();
            exportTemplate.Add(new JObject(
                new JProperty("ID", 0),
                new JProperty("Name", "Default Template"),
                new JProperty("Description", "Default Template"),
                new JProperty("IsPublic", false)));

            var templateList = COEExportTemplateBOList.GetUserTemplatesByDataViewId(dataViewId, COEUser.Name, true);
            foreach (var template in templateList)
            {
                exportTemplate.Add(new JObject(
                new JProperty("ID", template.ID),
                new JProperty("Name", template.Name),
                new JProperty("Description", template.Description),
                new JProperty("IsPublic", template.IsPublic)));
            }
            return exportTemplate;
        }

        private JArray GetExportResultsCriteria(bool? temp, int? templateId)
        {
            var resultsCriteria = new JArray();

            GenericBO bo = GetGenericBO(temp);
            COEDataView dataView = new COEDataView();
            dataView.GetFromXML(AddMolWt(bo.DataView).ToString());
            dataView.RemoveNonRelationalTables();

            XmlDocument templateCriterias = new XmlDocument();
            COEExportTemplateBO exportTemplateBo = templateId.HasValue ? COEExportTemplateBO.Get(templateId.Value) : null;
            if (exportTemplateBo != null && exportTemplateBo.ResultCriteria != null)
            {
                templateCriterias.Load(new StringReader(exportTemplateBo.ResultCriteria.ToString()));
            }

            foreach (var dataViewTable in dataView.Tables)
            {
                foreach (var dataViewField in dataViewTable.Fields)
                {
                    var visible = false;
                    var fieldAlias = dataViewField.Alias;
                    string xmlNamespace = "COE";
                    string xmlNSres = "COE.ResultsCriteria";
                    XmlNamespaceManager managerRes = new XmlNamespaceManager(new NameTable());
                    managerRes.AddNamespace(xmlNamespace, xmlNSres);
                    XmlNode templateFeildNode = templateCriterias.SelectSingleNode("//" + xmlNamespace + ":tables/COE:table/COE:field[@fieldId='" + dataViewField.Id + "']", managerRes);

                    var isStructureIndex = dataViewField.IndexType.ToString().ToUpper() == "CS_CARTRIDGE";
                    var isStructureMimeType = dataViewField.MimeType.ToString().ToUpper() == "CHEMICAL_X_CDX";
                    var isStructureColumn = isStructureIndex || isStructureMimeType;

                    if (templateFeildNode != null)
                    {
                        visible = bool.Parse(templateFeildNode.Attributes["visible"].Value);
                        if (!isStructureColumn)
                        {
                            fieldAlias = templateFeildNode.Attributes["alias"].Value;
                        }
                    }
                    if (isStructureColumn && templateId == null)
                    {
                        visible = true; // if is default template, structure columns should be selected by default
                    }
                    else if (isStructureColumn && templateId != null)
                    {
                        var tableData = exportTemplateBo.ResultCriteria.Tables.Find(x => x.Id == dataViewTable.Id);
                        var fieldData = tableData.Criterias.Find(x => x.Alias == fieldAlias && ((ResultsCriteria.Field)x).Id == dataViewField.Id);
                        if (fieldData != null)
                            visible = fieldData.Visible;
                    }
                    
                    var key = string.Format("{0}{1}", dataViewField.Id, Regex.Replace(fieldAlias, @"\s", string.Empty)).ToLower();
                    resultsCriteria.Add(new JObject(
                        new JProperty("key", key),
                        new JProperty("tableId", dataViewTable.Id),
                        new JProperty("tableName", dataViewTable.Alias),
                        new JProperty("fieldId", dataViewField.Id),
                        new JProperty("fieldName", fieldAlias),
                        new JProperty("visible", visible),
                        new JProperty("indexType", dataViewField.IndexType.ToString()),
                        new JProperty("mimeType", dataViewField.MimeType.ToString())));
                }
            }

            return resultsCriteria;
        }

        private ResultsCriteria GetResultsCriteria(List<ResultsCriteriaTableData> resultsCriteriaTableData)
        {
            var resultsCriteria = new ResultsCriteria();
            foreach (var criteriaTableData in resultsCriteriaTableData)
            {
                var isStructureIndex = !string.IsNullOrEmpty(criteriaTableData.IndexType) && criteriaTableData.IndexType.ToUpper() == "CS_CARTRIDGE";
                var isStructureMimeType = !string.IsNullOrEmpty(criteriaTableData.MimeType) && criteriaTableData.MimeType.ToUpper() == "CHEMICAL_X_CDX";
                var isStructureColumn = isStructureIndex || isStructureMimeType;

                var resultsCriteriaTable = resultsCriteria.Tables.Find(t => t.Id == criteriaTableData.TableId);
                if (resultsCriteriaTable == null)
                {
                    resultsCriteriaTable = new ResultsCriteria.ResultsCriteriaTable()
                    {
                        Id = criteriaTableData.TableId,
                        Criterias = new List<ResultsCriteria.IResultsCriteriaBase>()
                    };
                    resultsCriteria.Tables.Add(resultsCriteriaTable);
                }

                if (!criteriaTableData.Alias.ToLower().Contains("mol wt") && !criteriaTableData.Alias.ToLower().Contains("mol formula"))
                {
                    var field = new ResultsCriteria.Field
                    {
                        Id = criteriaTableData.FieldId,
                        Alias = criteriaTableData.Alias,
                        Visible = criteriaTableData.Visible
                    };

                    resultsCriteriaTable.Criterias.Add(field);
                }

                if (isStructureColumn && criteriaTableData.Alias.ToLower().Contains("mol wt"))
                {
                    ResultsCriteria.MolWeight molWeightCriteria = new ResultsCriteria.MolWeight();
                    molWeightCriteria.Alias = criteriaTableData.Alias;
                    molWeightCriteria.Id = criteriaTableData.FieldId;
                    molWeightCriteria.Visible = criteriaTableData.Visible;
                    resultsCriteriaTable.Criterias.Add(molWeightCriteria);
                }

                if (isStructureColumn && criteriaTableData.Alias.ToLower().Contains("mol formula"))
                {
                    ResultsCriteria.Formula formulaCriteria = new ResultsCriteria.Formula();
                    formulaCriteria.Alias = criteriaTableData.Alias;
                    formulaCriteria.Id = criteriaTableData.FieldId;
                    formulaCriteria.Visible = criteriaTableData.Visible;
                    resultsCriteriaTable.Criterias.Add(formulaCriteria);
                }
            }
            return resultsCriteria;
        }

        private COEHitListBO UpdateHitlistInternal(int id, HitlistData hitlistData)
        {
            var hitlistType = hitlistData.HitlistType;
            var hitlistBO = COEHitListBO.Get(hitlistType, id);
            if (hitlistBO == null)
                throw new IndexOutOfRangeException(string.Format("Cannot find the hit-list for ID, {0}", id));
            bool saveHitlist = false;
            if (hitlistType == HitListType.SAVED && hitlistBO.HitListID == 0)
            {
                // Saving temporary hit-list
                saveHitlist = true;
                hitlistBO = COEHitListBO.Get(HitListType.TEMP, id);
            }
            if (hitlistBO.HitListID > 0)
            {
                hitlistBO.Name = TrimtHitListName(hitlistData.Name);
                hitlistBO.Description = hitlistData.Description;
                hitlistBO.IsPublic = hitlistData.IsPublic.HasValue ? hitlistData.IsPublic.Value : false;
                if (hitlistBO.SearchCriteriaID > 0)
                {
                    var searchCriteriaBO = COESearchCriteriaBO.Get(hitlistBO.SearchCriteriaType, hitlistBO.SearchCriteriaID);
                    searchCriteriaBO.Name = hitlistBO.Name;
                    searchCriteriaBO.Description = hitlistBO.Description;
                    searchCriteriaBO.IsPublic = hitlistBO.IsPublic;
                    searchCriteriaBO = saveHitlist ? searchCriteriaBO.Save() : searchCriteriaBO.Update();
                    if (saveHitlist)
                    {
                        hitlistBO.SearchCriteriaID = searchCriteriaBO.ID;
                        hitlistBO.SearchCriteriaType = searchCriteriaBO.SearchCriteriaType;
                    }
                }
                if (saveHitlist)
                {
                    var idToDelete = hitlistBO.ID;
                    hitlistBO = hitlistBO.Save();
                    COEHitListBO.Delete(HitListType.TEMP, idToDelete);
                }
                else
                {
                    hitlistBO = hitlistBO.Update();
                }
            }
            return hitlistBO;
        }

        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/getRegNumberList")]
        [SwaggerOperation("GetRegNumberListFromHitlist")]
        [SwaggerResponse(200, type: typeof(string))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetRegNumberListFromHitlist(int hitlistId)
        {
            return await CallMethod(() =>
            {
                GetRegNumberListFromHitlistID.HitListID = hitlistId;
                var regNumberList = GetRegNumberListFromHitlistID.Execute();
                return regNumberList;
            });
        }
        
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/markedHitList")]
        [SwaggerOperation("GetMarkedHitList")]
        [SwaggerResponse(200, type: typeof(HitlistData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetMarkedHitList(bool? temp = null)
        {
            return await CallMethod(() =>
            {
                var markedHitList = GetMarkedHitListBO(temp);
                return new HitlistData(markedHitList);
            });
        }

        [HttpPut]
        [Route(Consts.apiPrefix + "hitlists/markedHitList/delete")]
        [SwaggerOperation("DeleteMarkedHitList")]
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> DeleteMarkedHitList(bool temp = false)
        {
            return await CallMethod(() =>
            {
                var markedHitList = GetMarkedHitListBO(temp);
                string message = string.Empty;
                BulkDelete command = null;
                List<string> failedRecords = new List<string>();
                try
                {
                    command = BulkDelete.Execute(markedHitList.ID, temp, string.Empty);
                    if (command.Result)
                    {
                        if (command.FailedRecords.Length > 0)
                        {
                            message = string.Format(Resource.FollowingRecordsNotDeleted_Label_Text, string.Join(", ", command.FailedRecords));
                            foreach (string id in command.FailedRecords)
                            {
                                failedRecords.Add(id);
                                markedHitList.UnMarkAllHits(); // In the old reg failed recrods are unmarked
                            }
                        }
                        else
                        {
                            message = string.Format("{0} {1} deleted successfully!", markedHitList.NumHits, markedHitList.NumHits == 1 ? "record" : "records");
                        }
                    }
                    else
                    {
                        message = Resource.NoRecordWasDeleted_Label_Text;
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }

                var response = new JObject(new JProperty("status", command.Result));
                if (failedRecords.Count > 0)
                {
                    var recordList = new JArray();
                    foreach (string id in failedRecords)
                    {
                        recordList.Add(new JObject() { new JProperty("id", id) });
                    }
                    response = new JObject();
                    response.Add(new JProperty("failedRecords", recordList));
                }

                return new ResponseData(message: message, data: response);
            });
        }

        [HttpPut]
        [Route(Consts.apiPrefix + "hitlists/markedHitList/approve")]
        [SwaggerOperation("ApproveMarkedHitList")]
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> ApproveMarkedHitList(bool temp = false)
        {
            return await CallMethod(() =>
            {
                var markedHitList = GetMarkedHitListBO(temp);
                var message = string.Empty;
                var result = BulkApprove.Execute(markedHitList.ID);
                return result ? new ResponseData(message: Resource.OperationSucceeded_Label_Text, data: new JObject(new JProperty("status", true))) :
                    new ResponseData(message: Resource.OperationProblem_Label_Text, data: new JObject(new JProperty("status", false)));
            });
        }

        [HttpPut]
        [Route(Consts.apiPrefix + "hitlists/markhit/{id}")]
        [SwaggerOperation("MarkHit")]
        [SwaggerResponse(200, type: typeof(HitlistData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> MarkHit(int id, bool temp = false)
        {
            return await CallMethod(() =>
            {
                var settings = RegAppHelper.RetrieveSettings().Where(s => s.GroupLabel.Equals("Search") && s.Name.Equals("MarkedHitsMax")).SingleOrDefault();
                var markedHitsMax = settings != null ? int.Parse(settings.Value) : 0;
                var markedHitList = GetMarkedHitListBO(temp);
                if (markedHitList.NumHits + 1 <= markedHitsMax)
                    markedHitList.MarkHit(id);
                return new HitlistData(markedHitList);
            });
        }

        [HttpPut]
        [Route(Consts.apiPrefix + "hitlists/markhit/all")]
        [SwaggerOperation("MarkAllHits")]
        [SwaggerResponse(200, type: typeof(HitlistData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> MarkAllHits(int hitlistId, string sort = null, bool temp = false)
        {
            return await CallMethod(() =>
            {
                var markedHitList = GetMarkedHitListBO(temp);
                markedHitList.UnMarkAllHits();

                var args = new Dictionary<string, object>();
                StringBuilder sql = new StringBuilder();
                var recordIds = new List<int>();

                if (hitlistId > 0)
                {
                    var hitlistBO = GetHitlistBO(hitlistId);
                    args.Add(":hitlistId", hitlistId);
                    if (hitlistBO.HitListType.Equals(HitListType.TEMP))
                    {
                        sql.Append("SELECT ID FROM COEDB.COETEMPHITLIST WHERE HITLISTID = :hitlistId");
                    }
                    else 
                    {
                        sql.Append("SELECT ID FROM COEDB.COESAVEDHITLIST WHERE HITLISTID = :hitlistId");
                    }
                }
                else
                {
                    if (temp)
                    {
                        sql.Append("SELECT TEMPBATCHID FROM REGDB.TEMPORARY_COMPOUND");
                    }
                    else
                    {
                        sql.Append("SELECT MIXTUREID FROM REGDB.VW_MIXTURE_REGNUMBER");                    
                    }
                }

                using (var reader = GetReader(sql.ToString(), args))
                {
                    while (reader.Read())
                    {
                        recordIds.Add(reader.GetInt32(0));
                    }
                }

                foreach (var id in recordIds)
                {
                    markedHitList.MarkHit(id);
                }

                return new HitlistData(markedHitList);
            });
        }

        [HttpPut]
        [Route(Consts.apiPrefix + "hitlists/unMarkhit/{id}")]
        [SwaggerOperation("UnMarkHit")]
        [SwaggerResponse(200, type: typeof(HitlistData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> UnMarkHit(int id, bool temp = false)
        {
            return await CallMethod(() =>
            {
                var markedHitList = GetMarkedHitListBO(temp);
                markedHitList.UnMarkHit(id);
                return new HitlistData(markedHitList);
            });
        }

        [HttpPut]
        [Route(Consts.apiPrefix + "hitlists/unMarkhit/all")]
        [SwaggerOperation("UnMarkAllHits")]
        [SwaggerResponse(200, type: typeof(HitlistData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> UnMarkAllHits(bool temp = false)
        {
            return await CallMethod(() =>
            {
                var markedHitList = GetMarkedHitListBO(temp);
                markedHitList.UnMarkAllHits();
                return new HitlistData(markedHitList);
            });
        }

        /// <summary>
        /// Creates a hit-list from a marked list
        /// </summary>
        /// <response code="200">Successful</response>
        /// <response code="400">Bad Request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="500">Internal Server Error</response>
        /// <param name="hitlistData">The hit-list information</param>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>A <see cref="ResponseData" /> object containing the ID of the created hit-list/></returns>
        [HttpPost]
        [Route(Consts.apiPrefix + "hitlists/mark/{temp}")]
        [SwaggerOperation("SaveMarkedHitlist")]
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> SaveMarkedHitlist(HitlistData hitlistData, bool temp = false)
        {
            return await CallMethod(() =>
            {
                CheckAuthentication();
                var markedHitList = GetMarkedHitListBO(temp);
                markedHitList.Name = hitlistData.Name;
                markedHitList.Description = hitlistData.Description;
                markedHitList.IsPublic = hitlistData.IsPublic.HasValue ? hitlistData.IsPublic.Value : false;
                markedHitList.HitListType = HitListType.SAVED;
                markedHitList.Save();
                return new ResponseData(id: markedHitList.ID);
            });
        }

        /// <summary>
        /// Returns all hit-lists.
        /// </summary>
        /// <response code="200">Successful</response>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>A list of hit-list objects</returns>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists")]
        [SwaggerOperation("GetHitlists")]
        [SwaggerResponse(200, type: typeof(List<HitlistData>))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetHitlists(bool? temp = null)
        {
            return await CallMethod(() =>
            {
                var result = new List<HitlistData>();
                var formGroup = GetFormGroup(temp);
                var tempHitLists = COEHitListBOList.GetRecentHitLists(Consts.REGDB, COEUser.Name, formGroup.Id, 10);
                foreach (var h in tempHitLists)
                {
                    result.Add(new HitlistData(h));
                }
                var savedHitLists = COEHitListBOList.GetSavedHitListList(Consts.REGDB, COEUser.Name, formGroup.Id);
                foreach (var h in savedHitLists)
                {
                    result.Add(new HitlistData(h));
                }
                return result;
            });
        }

        /// <summary>
        /// Returns last search criteria.
        /// </summary>
        /// <response code="200">Successful</response>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>Last search criteria object</returns>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/{temp}/restoreLastQuery")]
        [SwaggerOperation("GetLastHitlistStructureCriteria")]
        [SwaggerResponse(200, type: typeof(List<HitlistData>))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetLastHitlistStructureCriteria(bool? temp = false)
        {
            return await CallMethod(() =>
            {
                var formGroup = GetFormGroup(temp);
                var tempHitLists = COEHitListBOList.GetRecentHitLists(Consts.REGDB, COEUser.Name, formGroup.Id, 1);
                if (tempHitLists.Count > 0)
                {
                    var hitlistID = tempHitLists[0].HitListID;
                    var queryData = GetHitlistQueryInternal(hitlistID, temp);
                    var searchCriteria = new SearchCriteria();
                    searchCriteria.GetFromXML(queryData.SearchCriteria);
                    foreach (var item in searchCriteria.Items)
                    {
                        if (!(item is SearchCriteria.SearchCriteriaItem)) continue;
                        var searchCriteriaItem = (SearchCriteria.SearchCriteriaItem)item;
                        var structureCriteria = searchCriteriaItem.Criterium as SearchCriteria.StructureCriteria;
                        if (structureCriteria == null) continue;
                        var query = structureCriteria.Query4000;
                        if (!string.IsNullOrEmpty(query))
                            structureCriteria.Structure = query;
                    }
                    queryData.SearchCriteria = searchCriteria.ToString();
                    return queryData;
                }
                throw new RegistrationException("The hit-list has no query associated with it");
            });
        }

        /// <summary>
        /// Deletes a hit-list
        /// </summary>
        /// <remarks>Deletes a hit-list by its ID</remarks>
        /// <response code="200">Successful</response>
        /// <response code="400">Bad Request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="404">Not Found</response>
        /// <response code="500">Internal Server Error</response>
        /// <param name="id">The ID of hit-list to delete</param>
        /// <returns>The <see cref="ResponseData"/> object containing the ID of deleted hit-list</returns>
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        [HttpDelete]
        [Route(Consts.apiPrefix + "hitlists/{id:int}")]
        [SwaggerOperation("DeleteHitlist")]
        public async Task<IHttpActionResult> DeleteHitlist(int id)
        {
            return await CallMethod(() =>
            {
                COEHitListBO.Delete(HitListType.TEMP, id);
                COEHitListBO.Delete(HitListType.SAVED, id);
                return new ResponseData(id: id);
            });
        }

        /// <summary>
        /// Update a hit-list
        /// </summary>
        /// <remarks>Update a hit-list by its ID
        /// If the given hit-list is found only in the temporary list but the type is specified as saved,
        /// it is considered as a request to save the temporary hit-list as a saved hit-list.
        /// </remarks>
        /// <response code="200">Successful</response>
        /// <response code="400">Bad Request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="404">Not Found</response>
        /// <response code="500">Internal Server Error</response>
        /// <param name="id">The ID of hit-list to update</param>
        /// <param name="hitlistData">The hit list data</param>
        /// <returns>The <see cref="ResponseData"/> object containing the ID of updated hit-list</returns>
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        [HttpPut]
        [Route(Consts.apiPrefix + "hitlists/{id:int}")]
        [SwaggerOperation("UpdateHitlist")]
        public async Task<IHttpActionResult> UpdateHitlist(int id, [FromBody] HitlistData hitlistData)
        {
            return await CallMethod(() =>
            {
                var hitlistBO = UpdateHitlistInternal(id, hitlistData);
                return new ResponseData(id: hitlistBO.ID);
            });
        }

        /// <summary>
        /// Create a hit-list
        /// </summary>
        /// <response code="200">Successful</response>
        /// <response code="400">Bad Request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="500">Internal Server Error</response>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>A <see cref="ResponseData" /> object containing the ID of the created hit-list/></returns>
        [HttpPost]
        [Route(Consts.apiPrefix + "hitlists")]
        [SwaggerOperation("CreateHitlist")]
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> CreateHitlist(bool? temp = null)
        {
            return await CallMethod(() =>
            {
                var hitlistData = Request.Content.ReadAsAsync<JObject>().Result;
                var formGroup = GetFormGroup(temp);
                var genericBO = GenericBO.GetGenericBO("Registration", formGroup.Id);
                string name = hitlistData["Name"].ToString();
                bool isPublic = Convert.ToBoolean(hitlistData["IsPublic"].ToString());
                string dscription = hitlistData["Description"].ToString();
                string userID = COEUser.Name;
                int numHits = Convert.ToInt32(hitlistData["NumHits"].ToString());
                string databaseName = "REGDB";
                int hitListID = Convert.ToInt32(hitlistData["HitListID"].ToString());
                int dataViewID = formGroup.DataViewId;
                HitListType hitlistType = (HitListType)(int)hitlistData["HitlistType"];
                int searchcriteriaId = Convert.ToInt32(hitlistData["SearchcriteriaId"].ToString());
                string searchcriteriaType = hitlistData["SearchcriteriaType"].ToString();
                CambridgeSoft.COE.Framework.COEHitListService.DAL dal = null;
                var id = dal.CreateNewTempHitList(name, isPublic, dscription, userID, numHits, databaseName, hitListID, dataViewID, hitlistType, searchcriteriaId, searchcriteriaType);
                return new ResponseData(id: id);
            });
        }

        /// <summary>
        /// Returns the list of registry records for a hit-list
        /// </summary>
        /// <remarks>Returns the list of registry records for a hit-list by its ID</remarks>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Bad request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="500">Unexpected error</response>
        /// <param name="id">The hit-list ID</param>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>The promise to return a JSON object containing an array of registration records</returns>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/{id:int}/performQuery")]
        [SwaggerOperation("GetPerformQueryHitlist")]
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetHitlistRecords(int id, bool? temp = null)
        {
            return await CallMethod(() =>
            {
                var queryData = GetHitlistQueryInternal(id, temp);
                var newHitlistId = CreateTempHitlist(queryData, temp);
                return new ResponseData(id: newHitlistId);
            });
        }

        /// <summary>
        /// Returns the list of registry records for a hit-list
        /// </summary>
        /// <remarks>Returns the list of registry records for a hit-list by its ID</remarks>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Bad request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="500">Unexpected error</response>
        /// <param name="id">The hit-list ID</param>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>The object containing the search criteria as XML string</returns>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/{id:int}/query")]
        [SwaggerOperation("GetHitlistQuery")]
        [SwaggerResponse(200, type: typeof(QueryData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetHitlistQuery(int id, bool? temp = null)
        {
            return await CallMethod(() =>
            {
                var queryData = GetHitlistQueryInternal(id, temp);
                var searchCriteria = new SearchCriteria();
                searchCriteria.GetFromXML(queryData.SearchCriteria);
                foreach (var item in searchCriteria.Items)
                {
                    if (!(item is SearchCriteria.SearchCriteriaItem)) continue;
                    var searchCriteriaItem = (SearchCriteria.SearchCriteriaItem)item;
                    var structureCriteria = searchCriteriaItem.Criterium as SearchCriteria.StructureCriteria;
                    if (structureCriteria == null) continue;
                    var query = structureCriteria.Query4000;
                    if (!string.IsNullOrEmpty(query) && query.StartsWith("VmpD"))
                        structureCriteria.Structure = query;
                }
                queryData.SearchCriteria = searchCriteria.ToString();
                return queryData;
            });
        }

        /// <summary>
        /// Returns a hit-list by its ID
        /// </summary>
        /// <response code="200">Successful</response>
        /// <response code="400">Bad Request</response>
        /// <response code="404">Not Found</response>
        /// <response code="500">Internal Server Error</response>
        /// <param name="id1">The ID of the hit-list to use as the base</param>
        /// <param name="op">The name of operation to apply</param>
        /// <param name="id2">The ID of the hit-list to apply the operation</param>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>The list of hit-list objects</returns>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/{id1:int}/{op}/{id2:int}/records")]
        [SwaggerOperation("GetAdvHitlistRecords")]
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetAdvHitlistRecords(int id1, string op, int id2, bool? temp = null)
        {
            return await CallMethod(() =>
            {
                var formGroup = GetFormGroup(temp);
                int dataViewId = formGroup.DataViewId;
                var hitlistBO1 = GetHitlistBO(id1);
                if (hitlistBO1 == null)
                    throw new RegistrationException(string.Format("The hit-list identified by ID {0} is invalid", id1));
                var hitlistBO2 = GetHitlistBO(id2);
                if (hitlistBO2 == null)
                    throw new RegistrationException(string.Format("The hit-list identified by ID {0} is invalid", id2));
                string join;
                COEHitListBO newHitlist;
                switch (op)
                {
                    case "intersect":
                        join = "intersecting with";
                        newHitlist = COEHitListOperationManager.IntersectHitList(hitlistBO1.HitListInfo, hitlistBO2.HitListInfo, dataViewId);
                        break;
                    case "subtract":
                        join = "subtracted by";
                        newHitlist = COEHitListOperationManager.SubtractHitLists(hitlistBO1.HitListInfo, hitlistBO2.HitListInfo, dataViewId);
                        break;
                    default: // union
                        join = "combining with";
                        newHitlist = COEHitListOperationManager.UnionHitLists(hitlistBO1.HitListInfo, hitlistBO2.HitListInfo, dataViewId);
                        break;
                }
                string hitListDescription = string.Format("{0} {1} {2}", hitlistBO1.Description, join, hitlistBO2.Description);
                newHitlist.Name = string.Format("Search {0}", newHitlist.HitListID);
                newHitlist.Description = hitListDescription.Substring(0, Math.Min(hitListDescription.Length, 250));
                newHitlist.Update();
                return new ResponseData(id: newHitlist.HitListID);
            });
        }

        /// <summary>
        /// Save a hit-list
        /// </summary>
        /// <response code="200">Successful</response>
        /// <response code="400">Bad Request</response>
        /// <response code="404">Not Found</response>
        /// <response code="500">Internal Server Error</response>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>The count of marked hits</returns>
        [HttpPost]
        [Route(Consts.apiPrefix + "markedhits")]
        [SwaggerOperation("MarkedHitsSave")]
        public int MarkedHitsSave(bool? temp = null)
        {
            CheckAuthentication();
            var hitlistData = Request.Content.ReadAsAsync<JObject>().Result;
            var formGroup = GetFormGroup(temp);
            var genericBO = GenericBO.GetGenericBO("Registration", formGroup.Id);
            var hitlistBO = genericBO.MarkedHitList;
            hitlistBO.Name = TrimtHitListName(hitlistData["Name"].ToString());
            hitlistBO.Description = hitlistData["Description"].ToString();
            hitlistBO.HitListType = HitListType.SAVED;
            hitlistBO.Save();
            int markedCount = genericBO.GetMarkedCount();
            return markedCount;
        }

        /// <summary>
        /// Returns a hit-list by its ID
        /// </summary>
        /// <response code="200">Successful</response>
        /// <response code="400">Bad Request</response>
        /// <response code="404">Not Found</response>
        /// <response code="500">Internal Server Error</response>
        /// <param name="id">The ID of the hit-list that needs to be fetched</param>
        /// <returns>The matching hit-list</returns>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/{id:int}")]
        [SwaggerOperation("GetHitlist")]
        [SwaggerResponse(200, type: typeof(HitlistData))]
        public async Task<IHttpActionResult> GetHitlist(int id)
        {
            return await CallMethod(() =>
            {
                var hitlistBO = GetHitlistBO(id);
                return new HitlistData(hitlistBO);
            });
        }

        [HttpPost]
        [Route(Consts.apiPrefix + "search/records")]
        [SwaggerOperation("SearchRecords")]
        [SwaggerResponse(200, type: typeof(JObject))]
        [SwaggerResponse(401, type: typeof(JObject))]
        [SwaggerResponse(500, type: typeof(JObject))]
        public async Task<IHttpActionResult> SearchRecords([FromBody] QueryData queryData, int? skip = null, int? count = null, string sort = null)
        {
            return await CallMethod(() =>
            {
                return CreateTempHitlist(queryData, false);
            });
        }

        [HttpPost]
        [Route(Consts.apiPrefix + "search/temp-records")]
        [SwaggerOperation("SearchTempRecords")]
        [SwaggerResponse(200, type: typeof(JObject))]
        [SwaggerResponse(401, type: typeof(JObject))]
        [SwaggerResponse(500, type: typeof(JObject))]
        public async Task<IHttpActionResult> SearchTempRecords([FromBody] QueryData queryData, int? skip = null, int? count = null, string sort = null)
        {
            return await CallMethod(() =>
            {
                return CreateTempHitlist(queryData, true);
            });
        }

        [HttpPost]
        [Route(Consts.apiPrefix + "search/refineHitlist")]
        [SwaggerOperation("RefineHitlist")]
        [SwaggerResponse(200, type: typeof(JObject))]
        [SwaggerResponse(401, type: typeof(JObject))]
        [SwaggerResponse(500, type: typeof(JObject))]
        public async Task<IHttpActionResult> RefineHitlist([FromBody] QueryData queryData, int hitlistId, int? skip = null, int? count = null, string sort = null)
        {
            return await CallMethod(() =>
            {
                if (string.IsNullOrEmpty(queryData.SearchCriteria))
                    throw new RegistrationException("You must specify a search criteria");

                HitListInfo hitListInfo = GetHitlistInfo(hitlistId);
                string structureName;
                var searchCriteria = CreateSearchCriteria(queryData.SearchCriteria, out structureName);
                return GetRegistryRecordsListView(queryData.Temporary, skip, count, sort, hitListInfo, searchCriteria, queryData.HighlightSubStructures, true);
            });
        }

        /// <summary>
        /// Returns the list of registry records for a hit-list
        /// </summary>
        /// <remarks>Returns the list of registry records for a hit-list by its ID</remarks>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Bad request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="500">Unexpected error</response>
        /// <param name="id">The hit-list ID</param>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <param name="skip">The number of items to skip</param>
        /// <param name="count">The maximum number of items to return</param>
        /// <param name="sort">The sorting information</param>
        /// <returns>The promise to return a JSON object containing an array of registration records</returns>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/{id:int}/export")]
        [SwaggerOperation("ExportHitlistRecords")]
        [SwaggerResponse(200, type: typeof(JObject))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> ExportHitlistRecords(int id, bool? temp = null, int? skip = null, int? count = null, string sort = null)
        {
            return await CallMethod(() =>
            {
                return GetHitlistRecordsInternal(id, temp, skip, count, sort);
            });
        }

        /// <summary>
        /// Returns the exported file according to the specified file type for a hit-list
        /// </summary>
        /// <remarks>Returns the exported file according to the specified file type</remarks>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Bad request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="404">Not found</response>
        /// <response code="500">Unexpected error</response>
        /// <param name="id">The ID of the hit-list to be exported to the SD File</param>
        /// <param name="exportType">The export type expected</param>
        /// <param name="inputData">The data related to the Result Criteria and the Marked Records</param>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>The exported file for the matching hit-list</returns>
        [HttpPost]
        [Route(Consts.apiPrefix + "hitlists/{id:int}/export/{exportType}")]
        [SwaggerOperation("ExportHitlist")]
        [SwaggerResponse(200, type: typeof(string))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public HttpResponseMessage ExportHitlist(int id, string exportType, HitlistExportData inputData, bool? temp = null)
        {
            CheckAuthentication();
            var formGroup = GetFormGroup(temp);

            var markedHitList = GetMarkedHitListBO(temp);
            var isMarked = markedHitList.HitListID == id;

            PagingInfo pagingInfo = new PagingInfo();
            if (id > 0)
            {
                var hitlistBO = GetHitlistBO(id);
                pagingInfo.HitListID = hitlistBO.HitListID;
                pagingInfo.RecordCount = hitlistBO.HitListInfo.RecordCount;
                if (isMarked)
                    pagingInfo.HitListType = HitListType.MARKED;
            }
            else
            {
                pagingInfo.RecordCount = 1000;
            }

            var coex = new COEExport();
            var resultsCriteria = GetResultsCriteria(inputData.ResultsCriteriaTables);

            string exportedData = coex.GetData(resultsCriteria, pagingInfo, formGroup.Id, exportType);
            // CSBR-138818 Replacing <sub> with null while export.
            if (exportedData != null)
                exportedData = exportedData.Replace("<sub>", string.Empty).Replace("</sub>", string.Empty);

            try
            {
                using (var stream = new MemoryStream())
                {
                    var writer = new StreamWriter(stream);
                    writer.Write(exportedData);
                    writer.Flush();
                    stream.Position = 0;

                    var httpResponseMessage = new HttpResponseMessage();
                    httpResponseMessage.Content = new ByteArrayContent(stream.ToArray());
                    httpResponseMessage.Content.Headers.Add("x-filename", string.Format("Exported{0}HitsFromDV{1}.sdf", pagingInfo.RecordCount, formGroup.Id));
                    httpResponseMessage.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("chemical/x-mdl-sdfile");
                    httpResponseMessage.Content.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment");
                    httpResponseMessage.Content.Headers.ContentDisposition.FileName = "ExportedSDFfile.sdf";
                    httpResponseMessage.StatusCode = System.Net.HttpStatusCode.OK;

                    return httpResponseMessage;
                }
            }
            catch (IOException)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError);
            }
        }

        /// <summary>
        /// Return the results criteria for search
        /// </summary>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Bad request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="500">Unexpected error</response>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <param name="templateId">The selected template</param>
        /// <returns>The promise to return a JSON object containing an array of results criteria</returns>
        [HttpGet]
        [Route(Consts.apiPrefix + "hitlists/resultsCriteria")]
        [SwaggerOperation("GetResultsCriteria")]
        [SwaggerResponse(200, type: typeof(JObject))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetResultsCriteria(bool? temp = null, int? templateId = null)
        {
            return await CallMethod(() =>
            {
                return GetExportResultsCriteria(temp, templateId);
            });
        }

        /// <summary>
        /// Return the export templates for the current user
        /// </summary>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Bad request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="500">Unexpected error</response>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>The promise to return a JSON object containing an array of export templates</returns>
        [HttpGet]
        [Route(Consts.apiPrefix + "exportTemplates")]
        [SwaggerOperation("GetExportTemplates")]
        [SwaggerResponse(200, type: typeof(JObject))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetExportTemplates(bool? temp = null)
        {
            return await CallMethod(() =>
            {
                GenericBO bo = GetGenericBO(temp);
                return GetExportTemplates(bo.DataView.DataViewID);
            });
        }

        /// <summary>
        /// Returns the list of registry records to be printed
        /// </summary>
        /// <remarks>Returns the list of registry records for to be printed</remarks>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Bad request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="500">Unexpected error</response>
        /// <param name="id">The hit-list ID</param>
        /// <param name="markedIds">The list of ids for marked records</param>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <param name="skip">The number of items to skip</param>
        /// <param name="count">The maximum number of items to return</param>
        /// <param name="sort">The sorting information</param>
        /// <param name="highlightSubStructures">The flag indicating if the structures should be highlighted</param>
        /// <returns>The promise to return a JSON object containing an array of registration records</returns>
        [HttpPost]
        [Route(Consts.apiPrefix + "hitlists/{id:int}/print")]
        [SwaggerOperation("PrintRecords")]
        [SwaggerResponse(200, type: typeof(JObject))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> PrintRecords(int id, List<int> markedIds, bool? temp = null, int? skip = null, int? count = null, string sort = null, bool highlightSubStructures = false)
        {
            return await CallMethod(() =>
            {
                SearchCriteria searchCriteria = null;
                if (markedIds != null && markedIds.Count > 0)
                {
                    id = 0;
                    searchCriteria = new SearchCriteria();
                    searchCriteria.SearchCriteriaID = 1;
                    SearchCriteria.SearchCriteriaItem item;
                    item = new SearchCriteria.SearchCriteriaItem();
                    SearchCriteria.NumericalCriteria criteria = new SearchCriteria.NumericalCriteria();
                    criteria.InnerText = string.Join(",", markedIds);
                    criteria.Operator = SearchCriteria.COEOperators.IN;
                    criteria.Trim = SearchCriteria.Positions.None;
                    item.FieldId = (temp.HasValue && temp.Value) ? 100 : 101;
                    item.TableId = 1;
                    item.Criterium = criteria;
                    searchCriteria.Items.Add(item);
                }

                var result = (id > 0) ?
                    GetHitlistRecordsInternal(id, temp, skip, count, sort, highlightSubStructures) :
                    GetRegistryRecordsListView(temp, skip, count, sort, null, searchCriteria, highlightSubStructures);
                return result;
            });
        }

        /// <summary>
        /// Return the export templates for the current user
        /// </summary>
        /// <response code="200">Successful operation</response>
        /// <response code="400">Bad request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="500">Unexpected error</response>
        /// <param name="id">The template id</param>
        /// <param name="exportTemplateData">The template information</param>
        /// <param name="temp">The flag indicating whether or not it is for temporary records (default: false)</param>
        /// <returns>The promise to return a JSON object containing an array of export templates</returns>
        [HttpPost]
        [Route(Consts.apiPrefix + "hitlists/saveExportTemplates")]
        [SwaggerOperation("GetExportTemplates")]
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> SaveExportTemplates(int id, ExportTemplateData exportTemplateData, bool? temp = null)
        {
            return await CallMethod(() =>
            {
                GenericBO bo = GetGenericBO(temp);
                var exportTemplate = id > 0 ? COEExportTemplateBO.Get(id) : new COEExportTemplateBO();
                exportTemplate.Name = exportTemplateData.TemplateName;
                exportTemplate.Description = exportTemplateData.TemplateDescription;
                exportTemplate.IsPublic = exportTemplateData.IsPublic;
                exportTemplate.UserName = COEUser.Name;
                exportTemplate.DataViewId = bo.DataView.DataViewID;
                exportTemplate.ResultCriteria = GetResultsCriteria(exportTemplateData.ResultsCriteriaTableData);

                if (id > 0)
                {
                    exportTemplate.Update();
                }
                else
                {
                    exportTemplate.Save();
                    id = exportTemplate.ID;
                }

                return new ResponseData(id: id);
            });
        }

        /// <summary>
        /// Deletes an export template
        /// </summary>
        /// <remarks>Deletes an export by its ID</remarks>
        /// <response code="200">Successful</response>
        /// <response code="400">Bad Request</response>
        /// <response code="401">Unauthorized</response>
        /// <response code="404">Not Found</response>
        /// <response code="500">Internal Server Error</response>
        /// <param name="id">The ID of the export template to delete</param>
        /// <returns>The <see cref="ResponseData"/> object containing the ID of deleted export template</returns>
        [SwaggerResponse(200, type: typeof(ResponseData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        [HttpDelete]
        [Route(Consts.apiPrefix + "exportTemplates/{id:int}")]
        [SwaggerOperation("DeleteExportTemplate")]
        public async Task<IHttpActionResult> DeleteExportTemplate(int id)
        {
            return await CallMethod(() =>
            {
                COEExportTemplateBO.Delete(id);
                return new ResponseData(id: id);
            });
        }
    }
}