﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace PerkinElmer.COE.Registration.Server.Models
{
    /// <summary>
    /// The class for the CriteriaTable data object
    /// </summary>
    public class ResultsCriteriaTableData
    {
        public ResultsCriteriaTableData()
        {
        }

        [JsonConstructor]
        public ResultsCriteriaTableData(int tableId, int fieldId, string alias, bool visible)
        {
            TableId = tableId;
            FieldId = fieldId;
            Alias = alias;
            Visible = visible;

        }

        /// <summary>
        /// Gets or sets the tableId
        /// </summary>
        [JsonProperty(PropertyName = "tableId")]
        public int TableId { get; set; }

        /// <summary>
        /// Gets or sets the fieldId
        /// </summary>
        [JsonProperty(PropertyName = "fieldId")]
        public int FieldId { get; set; }

        /// <summary>
        /// Gets or sets the alias
        /// </summary>
        [JsonProperty(PropertyName = "alias")]
        public string Alias { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether or not this criterion is visible
        /// </summary>
        [JsonProperty(PropertyName = "visible")]
        public bool Visible { get; set; }
    }
}