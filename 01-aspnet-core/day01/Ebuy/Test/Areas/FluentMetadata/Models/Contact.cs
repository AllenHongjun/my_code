using System.ComponentModel.DataAnnotations;

namespace Test.Areas.FluentMetadata.Models
{
    public class Contact
    {
        [Required]
        public string FirstName { get; set; }

        [Required]
        public string LastName { get; set; }

        public string EmailAddress { get; set; }
    }
}