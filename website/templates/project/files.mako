<%inherit file="base.mako"/>
<%def name="title()">Files</%def>
<%def name="content()">
<div mod-meta='{"tpl": "project/project_header.mako", "replace": true}'></div>

<h4>Drag and drop files below to upload.</h4>
<div id="myGrid" class="hgrid"></div>

<script type="text/javascript">
    var gridData = ${grid_data};
</script>

<script>

  function modFolderView(row, args) {
    args = args || {};
    var name = row.name;
    // The + / - button for expanding/collapsing a folder
    var expander;
    if (row._node.children.length > 0 && row.depth > 0 || args.lazyLoad) {
      expander = row._collapsed ? HGrid.Html.expandElem : HGrid.Html.collapseElem;
    } else { // Folder is empty
      expander = '<span></span>';
    }
    // Concatenate the expander, folder icon, and the folder name
    var innerContent = [expander, HGrid.Html.folderIcon, name, HGrid.Html.errorElem].join(' ');
    return HGrid.Fmt.asItem(row, HGrid.Fmt.withIndent(row, innerContent, args.indent));
  }
  var nameColumn = {
    id: 'name',
    name: 'Name',
    sortkey: 'name',
    cssClass: 'hg-cell',
    folderView: modFolderView,
    itemView: HGrid.Columns.defaultItemView,
    sortable: true
  };

    HGrid.Col.ActionButtons.itemView = function() {
      var buttonDefs = [{
          text: '\<i class=\'icon-download-alt icon-white\'></i>',
          action: 'download',
          cssClass: 'btn btn-success btn-mini'
      }, {
          text: '\<i class=\'icon-trash icon-white\'></i>',
          action: 'delete',
          cssClass: 'btn btn-danger btn-mini'
      }];
      return HGrid.Fmt.buttons(buttonDefs);
    }

    HGrid.Col.ActionButtons.folderView = function() {
        var buttonDefs = [];
        if (this.options.uploads) {
          buttonDefs.push({
            text: '\<i class=\'icon-cloud-upload icon-white\'></i>',
            action: 'upload',
            cssClass: 'btn btn-primary btn-mini'
          });
        }
        if (buttonDefs) {
          return HGrid.Fmt.buttons(buttonDefs);
        }
        return '';
      }


var grid = new HGrid('#myGrid', {
    data: gridData,
    width: "100%",
    columns: [
        nameColumn,
        HGrid.Col.ActionButtons
    ],
    fetchUrl: function(row) {
        return row.urls.fetch;
    },
    downloadUrl: function(row) {
        return row.urls.download;
    },
    deleteUrl: function(row) {
        return row.urls.delete;
    },
    deleteMethod: 'delete',
    uploads: true,
    uploadUrl: function(row) {
        return row.urls.upload;
    },
    uploadMethod: 'post',
    uploadSuccess: function(file, item, data) {
        // TODO: Move to HGrid or HGrid-OSF
        data.parentID = item.parentID;
        this.removeItem(item.id);
        this.addItem(data);
    }
});

// TODO: Move to HGrid callback
grid.element.on('click', '.hg-item-content', function() {
    var viewUrl = grid.getByID($(this).attr('data-id')).urls.view;
    if (viewUrl) {
        window.location.href = viewUrl;
    }
});


// Don't show dropped content if user drags outside grid
window.ondragover = function(e) { e.preventDefault(); };
window.ondrop = function(e) { e.preventDefault(); };

</script>
</%def>
<%def name="stylesheets()">
<link rel="stylesheet" href="/static/vendor/hgrid/hgrid.css" type="text/css" />
<link rel="stylesheet" href="/static/vendor/hgrid/osf-hgrid.css" type="text/css" />
</%def>

<%def name="javascript()">
<script src="/static/vendor/dropzone/dropzone.js"></script>
<script src="/static/vendor/hgrid/hgrid.js"></script>
<script src='/static/js/filebrowser.js'></script>
</%def>

<%def name="javascript_bottom()">
% for script in tree_js:
<script type="text/javascript" src="${script}"></script>
% endfor

<script>
(function(global) {

var filebrowser = new FileBrowser('#myGrid', {
    data: gridData
});

})(window);
</script>
</%def>
