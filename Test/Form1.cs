using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Test
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        


        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {


            //就是这么简单呀 很多的东西都给你封装好了。。界面都不学要敲代码 直接拖一下控件就能够完成 

            // dataGridView 之前的牛逼之处呀。。
            dataGridView1.DataSource =
                SqlLiteHelper.GetDataTable("select * from MemberInfo");
            //dataGridView1.DataBindings();

        }
    }
}
