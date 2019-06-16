using BlogEngine.Core;
using BlogEngine.Core.Data.Contracts;
using BlogEngine.Core.Data.Models;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

/// <summary>
/// 角色管理。
/// </summary>
public class RolesController : ApiController
{
    readonly IRolesRepository repository;

    public RolesController(IRolesRepository repository)
    {
        this.repository = repository;
    }

    /// <summary>
    /// 分页获取数据列表
    /// </summary>
    /// <param name="take"></param>
    /// <param name="skip"></param>
    /// <param name="filter"></param>
    /// <param name="order"></param>
    /// <returns></returns>
    public IEnumerable<RoleItem> Get(int take = 10, int skip = 0, string filter = "", string order = "")
    {
        return repository.Find(take, skip, filter, order);
    }

    /// <summary>
    /// 获取一个角色信息
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public HttpResponseMessage Get(string id)
    {
        var result = repository.FindById(id);
        if (result == null)
            return Request.CreateResponse(HttpStatusCode.NotFound);

        return Request.CreateResponse(HttpStatusCode.OK, result);
    }

    /// <summary>
    /// 添加一个角色
    /// </summary>
    /// <param name="role"></param>
    /// <returns></returns>
    public HttpResponseMessage Post([FromBody]RoleItem role)
    {
        var result = repository.Add(role);
        if (result == null)
            return Request.CreateResponse(HttpStatusCode.NotFound);

        return Request.CreateResponse(HttpStatusCode.Created, result);
    }

    /// <summary>
    /// 移出多个角色信息
    /// </summary>
    /// <param name="items"></param>
    /// <returns></returns>
    public HttpResponseMessage Put([FromBody]List<RoleItem> items)
    {
        if (items == null || items.Count == 0)
            return Request.CreateResponse(HttpStatusCode.NotFound);

        foreach (var item in items)
        {
            repository.Remove(item.RoleName);
        }
        return Request.CreateResponse(HttpStatusCode.OK);
    }

    /// <summary>
    /// 删除一个角色
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public HttpResponseMessage Delete(string id)
    {
        repository.Remove(id);
        return Request.CreateResponse(HttpStatusCode.OK);
    }

    [HttpPut]
    public HttpResponseMessage ProcessChecked([FromBody]List<RoleItem> items)
    {
        if (items == null || items.Count == 0)
            return Request.CreateResponse(HttpStatusCode.NotFound);

        var action = Request.GetRouteData().Values["id"].ToString();

        if (action.ToLower() == "delete")
        {
            foreach (var item in items)
            {
                if (item.IsChecked)
                {
                    repository.Remove(item.RoleName);
                }
            }
        }
        return Request.CreateResponse(HttpStatusCode.OK);
    }

    /// <summary>
    /// 获取角色所有的权限
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    [HttpGet]
    public HttpResponseMessage GetRights(string id)
    {
        var result = repository.GetRoleRights(id);
        return Request.CreateResponse(HttpStatusCode.OK, result);
    }

    /// <summary>
    /// 获取用户所具有的角色
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    [HttpGet]
    public HttpResponseMessage GetUserRoles(string id)
    {
        var result = repository.GetUserRoles(id);
        return Request.CreateResponse(HttpStatusCode.OK, result);
    }

    /// <summary>
    /// 给角色分配权限
    /// </summary>
    /// <param name="rights"></param>
    /// <param name="id"></param>
    /// <returns></returns>
    [HttpPut]
    public HttpResponseMessage SaveRights([FromBody]List<Group> rights, string id)
    {
        repository.SaveRights(rights, id); 

        return Request.CreateResponse(HttpStatusCode.OK);
    }
}