﻿/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Collections;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using Profiles.Edit.Utilities;


namespace Profiles.GroupAdmin.Modules.GroupAdmin
{
    public partial class GroupAdmin : BaseModule
    {
        SessionManagement sm;
        Profiles.GroupAdmin.Utilities.DataIO data;
        protected void Page_Load(object sender, EventArgs e)
        {
            sm = new SessionManagement();

            DrawProfilesModule();
        }

        public GroupAdmin() : base() { }
        public GroupAdmin(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {


        }
        private void DrawProfilesModule()
        {

            if (sm.Session().UserID == 0)
                Response.Redirect(Root.Domain + "/search");

            data = new Profiles.GroupAdmin.Utilities.DataIO();

            imgAdd.ImageUrl = Root.Domain + "/framework/images/icon_roundArrow.gif";


            litBackLink.Text = "<b>Manage Groups</b>";

            SqlDataReader reader;
            List<Group> groups = new List<Group>();

            reader = data.GetActiveGroups();
            while (reader.Read())
            {
                //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                groups.Add(new Group(reader["GroupName"].ToString(), reader.GetInt64(reader.GetOrdinal("ViewSecurityGroup")), reader["ViewSecurityGroupName"].ToString(), 
                    reader["EndDate"].ToString(), reader.GetInt32(reader.GetOrdinal("GroupID")), reader.GetInt64(reader.GetOrdinal("GroupNodeID"))));
            }
            reader.Close();

            gvGroups.DataSource = groups;
            gvGroups.DataBind();
            gvGroups.CellPadding = 2;


            SqlDataReader deletedReader;
            List<Group> deletedGroups = new List<Group>();

            deletedReader = data.GetDeletedGroups();
            while (deletedReader.Read())
            {
                //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                deletedGroups.Add(new Group(deletedReader["GroupName"].ToString(), deletedReader.GetInt64(deletedReader.GetOrdinal("ViewSecurityGroup")), deletedReader["ViewSecurityGroupName"].ToString(),
                    deletedReader["EndDate"].ToString(), deletedReader.GetInt32(deletedReader.GetOrdinal("GroupID")), deletedReader.GetInt64(deletedReader.GetOrdinal("GroupNodeID"))));
            }
            deletedReader.Close();

            gvDeletedGroups.DataSource = deletedGroups;
            gvDeletedGroups.DataBind();
            gvDeletedGroups.CellPadding = 2;
        }

        protected void fillGroupsGrid()
        {
            SqlDataReader reader;
            List<Group> groups = new List<Group>();

            reader = data.GetActiveGroups();
            while (reader.Read())
            {
                //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                groups.Add(new Group(reader["GroupName"].ToString(), reader.GetInt64(reader.GetOrdinal("ViewSecurityGroup")), reader["ViewSecurityGroupName"].ToString(),
                    reader["EndDate"].ToString(), reader.GetInt32(reader.GetOrdinal("GroupID")), reader.GetInt64(reader.GetOrdinal("GroupNodeID"))));
            }
            reader.Close();

            gvGroups.DataSource = groups;
            gvGroups.DataBind();
            gvGroups.CellPadding = 2;

            SqlDataReader deletedReader;
            List<Group> deletedGroups = new List<Group>();

            deletedReader = data.GetDeletedGroups();
            while (deletedReader.Read())
            {
                //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                deletedGroups.Add(new Group(deletedReader["GroupName"].ToString(), deletedReader.GetInt64(deletedReader.GetOrdinal("ViewSecurityGroup")), deletedReader["ViewSecurityGroupName"].ToString(),
                    deletedReader["EndDate"].ToString(), deletedReader.GetInt32(deletedReader.GetOrdinal("GroupID")), deletedReader.GetInt64(deletedReader.GetOrdinal("GroupNodeID"))));
            }
            deletedReader.Close();

            gvDeletedGroups.DataSource = deletedGroups;
            gvDeletedGroups.DataBind();
            gvDeletedGroups.CellPadding = 2;
        }

        protected void btnInsert_OnClick(object sender, EventArgs e)
        {
            string groupName = txtGroupName.Text;
            int visibility = Convert.ToInt32(ddVisibility.SelectedValue);
            string endDate = txtEndDate.Text;
            Utilities.DataIO data = new Utilities.DataIO();
            data.AddGroup(groupName, visibility, endDate);
            fillGroupsGrid();
        }


        protected void lnkDelete_OnClick(object sender, EventArgs e)
        {
            ImageButton lb = (ImageButton)sender;

            Profiles.Proxy.Utilities.DataIO data = new Profiles.Proxy.Utilities.DataIO();
            data.DeleteProxy(lb.CommandArgument);


            DrawProfilesModule();


        }

        protected void gvGroups_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Group proxy = (Group)e.Row.DataItem;

                ImageButton lnkDelete = (ImageButton)e.Row.FindControl("lnkDelete");
            }
        }

        protected void gvGroups_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvGroups.EditIndex = -1;

            fillGroupsGrid();
            upnlEditSection.Update();
        }

        protected void gvGroups_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvGroups.EditIndex = e.NewEditIndex;
            upnlEditSection.Update();
        }

        protected void gvGroups_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int groupID = Convert.ToInt32(gvGroups.DataKeys[e.RowIndex].Values[0].ToString());
            data.DeleteGroup(groupID);
            fillGroupsGrid();
            upnlEditSection.Update();
        }


        protected void gvGroups_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            fillGroupsGrid();
            upnlEditSection.Update();
        }

        protected void gvGroups_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            TextBox txtGroupName = (TextBox)gvGroups.Rows[e.RowIndex].FindControl("txtGroupName");
            TextBox txtVisibility = (TextBox)gvGroups.Rows[e.RowIndex].FindControl("txtVisibility");
            TextBox txtEndDate = (TextBox)gvGroups.Rows[e.RowIndex].FindControl("txtEndDate");
            int groupID = Convert.ToInt32(gvGroups.DataKeys[e.RowIndex].Values[0].ToString());
            Int64 vis = Convert.ToInt64(gvGroups.DataKeys[e.RowIndex].Values[1].ToString());
            string visString = txtVisibility.Text;
            if ("Public".Equals(txtVisibility.Text)) vis = -1;
            if ("Users".Equals(txtVisibility.Text)) vis = -20;

            string endDate = null;
            if (!txtEndDate.Text.Equals("")) endDate = txtEndDate.Text;

            //data.UpdateAward(hdURI.Value, txtAwardName.Text, txtAwardInst.Text, txtYr1.Text, txtYr2.Text, this.PropertyListXML);
            data.UpdateGroup(groupID, txtGroupName.Text, vis, endDate);
            gvGroups.EditIndex = -1;
            Session["pnlInsertAward.Visible"] = null;
            fillGroupsGrid();
            upnlEditSection.Update();
        }

        protected void gvDeletedGroups_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int groupID = Convert.ToInt32(gvDeletedGroups.DataKeys[e.NewEditIndex].Values[0].ToString());
            data.RestoreGroup(groupID);
            fillGroupsGrid();
            upnlEditSection.Update();
        }

        protected void gvDeletedGroups_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Group group = (Group)e.Row.DataItem;

                ImageButton lnkDelete = (ImageButton)e.Row.FindControl("lnkDelete");
            }
        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }

        class Group
        {
            public Group(string GroupName, Int64 ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, int GroupID, Int64 GroupNodeID)
            {
                this.GroupName = GroupName;
                this.ViewSecurityGroup = ViewSecurityGroup;
                this.ViewSecurityGroupName = ViewSecurityGroupName;
                this.EndDate = EndDate;
                this.GroupID = GroupID;
                this.GroupNodeID = GroupNodeID;
                this.GroupURI = Root.Domain + "/Profile/" + GroupNodeID;
            }


            public string GroupName { get; set; }
            public Int64 ViewSecurityGroup { get; set; }
            public string ViewSecurityGroupName { get; set; }
            public string EndDate { get; set; }
            public int GroupID { get; set; }
            public Int64 GroupNodeID { get; set; }
            public string GroupURI { get; set; }
        }

    }
}