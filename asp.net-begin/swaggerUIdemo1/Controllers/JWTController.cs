using JWT;
using JWT.Algorithms;
using JWT.Serializers;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace swaggerUIdemo1.Controllers
{
    public class JWTController : ApiController
    {

        #region 什么是 JWT  。。如何使用JWT    JWT.NET  使用是什么组件  别人是如何来使用 下载一个 demo学习一下 如何来使用
        //使用 jwt  头部.PreLoad.signture    中间的内容 是base64  密钥secret 作为 token 
        /*
         token 如果localstorage 删除 就相当于登出 
         redis 中 是否有值 作为状态保持
         token 当中 也是过期时间的...验证如何这个过期了 就不能登录了..
         
        找到对的资源好的资源    和现在使用的技术 完全吻合的资源 。。系列的教程。。完整 一步一步的教程。。跟着学习完了这个教程。。基本的功能 也就会一些了。。 

        零钱  查询 系列教程
        分组 连接 查询 系列教程。。。

         什么是  这个东西是什么   这个东西 demo 当中 如何 使用 。。在项目当中如何使用。。  

        其他优化 进化的地方 就 分布。。。那一些不会的点。。就慢慢的琢磨再去研究。  

        分组 查询 。。sql 数据 查询 使用 多用用 多使用 使用。。   跨站请求伪造

        什么是 JWT -- JSON WEB TOKEN


        Access-Control-Allow-Origin: *。
        token 放在请求头当中 每次都发送给服务端。。 token就是一个令牌  解密令牌中的数据 验证用户是否已经登陆

        token 如何泄露的怎么办  token 的过期时间 。。刷新token 验证token 的过期时间。。
        
        
        JWT 的样子        eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ


        这个也就是token  
        eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJVc2VyTmFtZSI6ImhvbmdqeSIsIlVzZXJJZCI6MzIsIlJvbGVzIjpbeyJwZXJtaXNzaW9ucyI6WyJwZXJtaXNzaW9uOnZpZXciLCJwZXJtaXNzaW9uOmNyZWF0ZSIsInBlcm1pc3Npb246ZWRpdCIsInBlcm1pc3Npb246ZGVsZXRlIiwicGVybWlzc2lvbjphdWRpdCJdLCJpZCI6MSwibmFtZSI6IueuoeeQhuWRmCIsImFjY2Vzc0xldmVsIjoxLCJhY2Nlc3NMZXZlbE5hbWUiOiJBZG1pbmlzdHJhdG9yIiwiZGVzY3JpcHRpb24iOiIifSx7InBlcm1pc3Npb25zIjpbXSwiaWQiOjIsIm5hbWUiOiLlvIDlj5EiLCJhY2Nlc3NMZXZlbCI6MCwiYWNjZXNzTGV2ZWxOYW1lIjoiVXNlciIsImRlc2NyaXB0aW9uIjoiIn1dLCJJc0FkbWluIjp0cnVlLCJleHAiOjk0NjA4MDAwMC4wfQ.Qn6OaoxFqeBPMz6sIsYxUO4Lp6clE3TuI0d39O_DIro



        用户使用用户名密码来请求服务器
        服务器进行验证用户的信息
        服务器通过验证发送给用户一个token
        客户端存储token，并在每次请求时附送上这个token值
        服务端验证token值，并返回数据

        一个组件 


        jwt的第三部分是一个签证信息，这个签证信息由三部分组成：

        header (base64后的)
        payload (base64后的)
        secret

        // javascript  头部 和 中间部门 base64 然后加盐 HMaCSA256 密码 使用一个组件 就帮你把机密 什么的这些事情 全部都给搞定了。。
        如果token 被人截获了怎么办（钥匙丢了。）  https  

        比分布式session更加省事  保护好secret私钥，该私钥非常重要。

        var encodedString = base64UrlEncode(header) + '.' + base64UrlEncode(payload);

        var signature = HMACSHA256(encodedString, 'secret'); // TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ

        JSON Web Token - 在Web应用间安全地传递信息
        1、时间戳，过期则需再次登录

        2、客户端记录调用api的总请求次数与服务端返回的用户总请求次数是否差距过大，过大则提醒用户未知风险，需再次登录

        token要设置http only。。。

        3 - token如果你结合 oauth的话 可以设置两个token，一个access 一个 refresh，这样access是短时间的，时间到了用refresh去换新的token。
        4 - 不推荐服务器端记录token并且标明注销，但是你非要这么做也不是不可以。
        5. 使用https 来方式用户数据被截获 这样更加的安全。。 

        要注意一下 安装的组件库 最低依赖的版本。。 有些新的 组件 是不依赖低版本的功能的。  

        搞明白 用户登陆 权限验证  授权。。  缓存 记录 。。
        利于分布式  用户量大 

        数据库查询 使用 要是我的优势。。




        http://blog.leapoahead.com/2015/09/06/understanding-jwt/
         
         */
        #endregion


        private string secret = "123fdjsiaofjdioasnfdasfkdlasfnk";


        #region 加密创建用户的token 
        /// <summary>
        /// 登陆成功 更加每一个用户创建一个用户token 
        /// </summary>
        /// <returns></returns>
        private string CreateToken()
        {
            IDateTimeProvider provider = new UtcDateTimeProvider();
            var now = provider.GetNow();

            //过期时间需要的是一个时间戳的格式  距离 1970，1，1，0，0，0， 的秒数   

            // 验证是否登陆的状态保持 普通session 的验证登陆方式  jwt   Json Web token 的 登陆 验证方式  微信oauth2.0 登陆验证的方式 。

            // 




            var unixEpoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc); // or use JwtValidator.UnixEpoch
            var secondsSinceEpoch = Math.Round((now - unixEpoch).TotalSeconds);

            var payload = new Dictionary<string, object>
            {
                    { "name", "MrBug" },
                    {"exp",secondsSinceEpoch+100 },
                    {"jti","luozhipeng" }
            };

            string msg = "secondsSinceEpoch" + secondsSinceEpoch;

            IJwtAlgorithm algorithm = new HMACSHA256Algorithm();
            IJsonSerializer serializer = new JsonNetSerializer();
            IBase64UrlEncoder urlEncoder = new JwtBase64UrlEncoder();
            IJwtEncoder encoder = new JwtEncoder(algorithm, serializer, urlEncoder);

            // 将preload 和 secrect 生成对应的编码 base  然后返回 给用户 使用起来 看起来 比较的简单。。



            var token = encoder.Encode(payload, secret);

            msg += "token:  " + token;
            return msg;
        } 
        #endregion


        private void TokenDecode(string token)
        {   
            // 可以找一下 教程 或者 找一下 官方的demo
            try
            {
                IJsonSerializer serializer = new JsonNetSerializer();
                IDateTimeProvider provider = new UtcDateTimeProvider();
                IJwtValidator validator = new JwtValidator(serializer, provider);
                IBase64UrlEncoder urlEncoder = new JwtBase64UrlEncoder();
                IJwtDecoder decoder = new JwtDecoder(serializer, validator, urlEncoder);

                var json = decoder.Decode(token, secret, verify: true);//token为之前生成的字符串
                Console.WriteLine(json);
            }
            catch (TokenExpiredException)
            {
                Console.WriteLine("Token has expired");
            }
            catch (SignatureVerificationException)
            {
                Console.WriteLine("Token has invalid signature");
            }


        }


        //自定义json解析器，只要继承IJsonSerializer接口

        //public class CustomJsonSerializer : IJsonSerializer
        //{
        //    public string Serialize(object obj)
        //    {
        //        return null;
        //        // Implement using favorite JSON Serializer
        //    }

        //    public T Deserialize<T>(string json)
        //    {
        //        //return json;
        //        // Implement using favorite JSON Serializer
        //    }
        //}

        /*
         自定义JSON序列化

默认的JSON序列化由JsonNetSerializer完成
             
         
             */

        public void Test()
        {
            JsonSerializer customJsonSerializer = new JsonSerializer
            {
                // All json keys start with lowercase characters instead of the exact casing of the model/property. e.g. fullName
                ContractResolver = new CamelCasePropertyNamesContractResolver(),

                // Nice and easy to read, but you can also do Formatting.None to reduce the payload size (by hardly anything...)
                Formatting = Formatting.Indented,

                // The best date/time format/standard.
                DateFormatHandling = DateFormatHandling.IsoDateFormat,

                // Don't add key/values when the value is null.
                NullValueHandling = NullValueHandling.Ignore,

                // Use the enum string-value, not the implicit int value, e.g. "oolor" : "red"
               // Newtonsoft.Json.Converters.Add(new StringEnumConverter())
            };
            IJsonSerializer serializer = new JsonNetSerializer(customJsonSerializer);
        }


    }
}
