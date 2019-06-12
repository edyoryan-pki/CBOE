﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using Microsoft.Web.Http;
using PerkinElmer.COE.Inventory.API.Code;
using PerkinElmer.COE.Inventory.Model;
using PerkinElmer.COE.Inventory.DAL;
using Swashbuckle.Swagger.Annotations;
using PerkinElmer.COE.Inventory.API.Filters;

namespace PerkinElmer.COE.Inventory.API.Controllers
{
    /// <summary>
    /// The inventory container controller
    /// </summary>
    [ApiVersion(Consts.apiVersion)]
    public class ContainerController : InvApiController
    {
        /// <summary>
        /// 
        /// </summary>
        protected ContainerDAL internalContainerDAL;

        /// <summary>
        /// DAL for containers
        /// </summary>
        protected ContainerDAL containerDAL
        {
            get
            {
                if (internalContainerDAL == null)
                {
                    internalContainerDAL = new ContainerDAL();
                }
                return internalContainerDAL;
            }
        }

        /// <summary>
        /// Constructor for ContainerController
        /// </summary>
        public ContainerController()
        {
        }

        /// <summary>
        /// Constructor for ContainerController
        /// </summary>
        public ContainerController(IInventoryDBContext context)
        {
            internalContainerDAL = new ContainerDAL(context);
        }

        /// <summary>
        /// Get container by internal id
        /// </summary>
        /// <param name="id">Internal id</param>
        /// <returns>Container</returns>
        [HttpGet]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/{id:int}")]
        [SwaggerOperation("Containers")]
        [SwaggerResponse(200, type: typeof(ContainerData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetContainerById(int id)
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                ContainerData container = containerDAL.GetContainerById(id);
                if (container == null)
                    throw new IndexOutOfRangeException(string.Format("Cannot find the container, {0}", id));

                responseMessage = Request.CreateResponse(statusCode, container);
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Get containers by location id
        /// </summary>
        /// <param name="locationId">Internal location id</param>
        /// <returns>List of Containers</returns>
        [HttpGet]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/location/{locationId:int}")]
        [SwaggerOperation("Containers")]
        [SwaggerResponse(200, type: typeof(ContainerData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetContainersByLocationId(int locationId)
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                List<ContainerData> containers = containerDAL.GetContainersByLocationId(locationId);
                
                responseMessage = Request.CreateResponse(statusCode, containers);
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Get container by barcode
        /// </summary>
        /// <param name="barcode">Barcode</param>
        /// <returns>Container</returns>
        [HttpGet]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/barcode/{barcode}")]
        [SwaggerOperation("Containers")]
        [SwaggerResponse(200, type: typeof(ContainerData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetContainerByBarcode(string barcode)
        {
            HttpResponseMessage responseMessage;
            try
            {
                // TODO: Should check authentication and authorization
                var statusCode = HttpStatusCode.OK;

                ContainerData container = containerDAL.GetContainerByBarcode(barcode);
                if (container == null)
                    throw new IndexOutOfRangeException(string.Format("Cannot find the container, {0}", barcode));
                responseMessage = Request.CreateResponse(statusCode, container);
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Create a container
        /// </summary>
        /// <param name="container">The container data</param>
        /// <returns>Container</returns>
        [HttpPost]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers")]
        [SwaggerOperation("Containers")]
        [SwaggerResponse(200, type: typeof(ContainerData))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> CreateContainer(ContainerData container)
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                var newContainerId = containerDAL.CreateContainer(container);
                var newContainer = containerDAL.GetContainerById(newContainerId);

                responseMessage = Request.CreateResponse(statusCode, newContainer);
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Update a container
        /// </summary>
        /// <param name="containerId"></param>
        /// <param name="container"></param>
        /// <returns>Container</returns>
        [HttpPut]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers")]
        [SwaggerOperation("Containers")]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> UpdateContainer(int containerId, ContainerData container)
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                containerDAL.UpdateContainer(containerId, container);

                responseMessage = Request.CreateResponse(statusCode, "The container was updated successfully!");
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Update container remaining quantity
        /// </summary>
        /// <param name="containerId">The container id to be updated</param>
        /// <param name="remainingQuantity">The remaining quantity to update</param>
        /// <returns>Container</returns>
        [HttpPut]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/remainingQuantity")]
        [SwaggerOperation("UpdateContainerRemainingQuantity")]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> UpdateContainerRemainingQuantity(int containerId, decimal remainingQuantity)
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                containerDAL.UpdateContainerRemainingQuantity(containerId, remainingQuantity);

                responseMessage = Request.CreateResponse(statusCode, "The container remaining quantity was updated successfully!");
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Move container to a particular location
        /// </summary>
        /// <param name="containerId">The container id to be moved</param>
        /// <param name="locationId">The location id to which the container should be moved</param>
        /// <returns>Container</returns>
        [HttpPut]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "container/moveContainer")]
        [SwaggerOperation("MoveContainer")]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> MoveContainer(int containerId, int locationId)
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                var locationValue = containerDAL.MoveContainer(containerId, locationId);

                responseMessage = Request.CreateResponse(statusCode, locationValue);
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Update container status
        /// </summary>
        /// <param name="containerId">The container id to be updated</param>
        /// <param name="containerStatusId">The container status id to update</param>
        /// <returns>Container</returns>
        [HttpPut]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/status")]
        [SwaggerOperation("UpdateContainerStatus")]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> UpdateContainerStatus(int containerId, int containerStatusId)
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                containerDAL.UpdateContainerStatus(containerId, containerStatusId);

                responseMessage = Request.CreateResponse(statusCode, "The container status was updated successfully!");
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Get container types
        /// </summary>
        /// <returns>List of container types</returns>
        [HttpGet]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/types")]
        [SwaggerOperation("GetContainerTypes")]
        [SwaggerResponse(200, type: typeof(List<ContainerTypeData>))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetContainerTypes()
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                List<ContainerTypeData> containerTypes = containerDAL.GetContainerTypes();

                responseMessage = Request.CreateResponse(statusCode, containerTypes);
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Get container status
        /// </summary>
        /// <returns>List of container status</returns>
        [HttpGet]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/status")]
        [SwaggerOperation("GetContainerStatus")]
        [SwaggerResponse(200, type: typeof(List<ContainerStatusData>))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetContainerStatus()
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                List<ContainerStatusData> containerStatus = containerDAL.GetContainerStatus();

                responseMessage = Request.CreateResponse(statusCode, containerStatus);
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Get container units
        /// </summary>
        /// <returns>List of container units</returns>
        [HttpGet]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/units")]
        [SwaggerOperation("GetContainerUnits")]
        [SwaggerResponse(200, type: typeof(List<UnitData>))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> GetContainerUnits()
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                List<UnitData> containerUnits = containerDAL.GetContainerUnits();

                responseMessage = Request.CreateResponse(statusCode, containerUnits);
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Get containers based on the filters parameters
        /// </summary>
        /// <returns>List of containers</returns>
        [HttpPost]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/search")]
        [SwaggerOperation("SearchContainers")]
        [SwaggerResponse(200, type: typeof(List<ContainerData>))]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> SearchContainers([FromBody] SearchContainerData searchContainerData)
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                List<ContainerData> containers = containerDAL.GetContainers(searchContainerData);

                responseMessage = Request.CreateResponse(statusCode, containers);
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }

        /// <summary>
        /// Delete container
        /// </summary>
        /// <param name="id">The container id to be deleted</param>
        /// <returns>Container</returns>
        [HttpDelete]
        [ApiKeyAuthenticationFilter]
        [Route(Consts.apiPrefix + "containers/{id:int}")]
        [SwaggerOperation("DeleteContainer")]
        [SwaggerResponse(400, type: typeof(Exception))]
        [SwaggerResponse(401, type: typeof(Exception))]
        [SwaggerResponse(404, type: typeof(Exception))]
        [SwaggerResponse(500, type: typeof(Exception))]
        public async Task<IHttpActionResult> DeleteContainer(int id)
        {
            HttpResponseMessage responseMessage;
            try
            {
                var statusCode = HttpStatusCode.OK;

                containerDAL.DeleteContainer(id);

                responseMessage = Request.CreateResponse(statusCode, "The container was deleted successfully!");
            }
            catch (Exception ex)
            {
                responseMessage = CreateErrorResponse(ex);
            }

            return await Task.FromResult<IHttpActionResult>(ResponseMessage(responseMessage));
        }
    }
}
