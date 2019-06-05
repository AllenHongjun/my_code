using CZBK.ItcastOA.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CZBK.ItcastOA.IBLL
{
    public partial interface IRoleInfoService : IBaseService<RoleInfo>
    {
        bool SetRoleActionInfo(int roleId,List<int>actionIdList);
    }
}
