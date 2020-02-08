using System.Web;

namespace Test.Areas.TimingFilter.Utility
{
    public class StatefulStoragePerRequest : DictionaryStatefulStorage
    {
        // Ambient environment constructor
        public StatefulStoragePerRequest()
            : base(() => HttpContext.Current.Items)
        {
        }

        // IoC-friendly constructor
        public StatefulStoragePerRequest(HttpContextBase context)
            : base(() => context.Items)
        {
        }
    }
}
