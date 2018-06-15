<script>
	$(function(){
		$("#columnList").bootstrapTable({
			url:"${managerPath}/${model?default("")}/column/list.do?modelId=${Session.model_id_session?default(0)}&modelTitle=${Session.model_title_session?default('')}",
			contentType : "application/x-www-form-urlencoded",
			queryParamsType : "undefined",
			toolbar: "#toolbar",
			idField: 'categoryId',
            treeShowField: 'categoryTitle',
            parentIdField: 'categoryCategoryId',
	    	columns: [
	    		{ 
	    			checkbox: true
	    		},{
		        	field: 'categoryId',
		        	title: '编号1',
		        	align: 'center'
		    	},{
		        	field: 'categoryTitle',
		        	title: '标题',
		        	align: 'left',
		        	formatter:function(value,row,index) {
		        	    <@shiro.hasPermission name="column:update">
		        		var url = "${managerPath}/${model?default("")}/column/"+row.categoryId+"/edit.do?modelId=${Session.model_id_session?default(0)}&modelTitle=${Session.model_title_session?default('')}";
		        		return "<a href=" +url+ " target='_self'>" + value + "</a>";
		        		</@shiro.hasPermission>
		        		<@shiro.lacksPermission name="column:update">
	    			    return value;
	    		        </@shiro.lacksPermission>
		        	}
		        	
		    	},{
		        	field: 'columnType',
		        	title: '属性',
		        	align: 'center',
		        	formatter:function(value,row,index) {
		        		if(value == 1){
		        			return "列表";
		        		}else if(value == 2){
		        			return "单页";
		        		}else if(value == 3){
		        			return "外部链接";
		        		}
		        	}
		    	},{
		        	field: 'columnPath',
		        	title: '链接地址',
		        	align: 'left',
		        	formatter:function(value,row,index) {
		        		return "{ms:global.url/}"+value+"/index.html";
		        	}
		    	},{
		        	field: 'columnListUrl',
		        	title: '列表地址',
		        	align: 'left',
		        	formatter:function(value,row,index) {
		        		if(value != null){
		        			return value;
		        		}else{
		        			return "";
		        		}
		        	}
		    	},{
		        	field: 'columnUrl',
		        	title: '内容地址',
		        	align: 'left',
		        	formatter:function(value,row,index) {
		        		if(row.columnType == 1){
		        			return value;
		        		}else{
		        			return "";
		        		}
		        	}
		    	},{
		        	field: 'columnUrl',
		        	title: '封面地址',
		        	align: 'left',
		        	formatter:function(value,row,index) {
		        		if(row.columnType == 2){
		        			return value;
		        		}else{
		        			return "";
		        		}
		        	}
		    	}]
	    })
	})
 
	
	//增加按钮
	$("#addColumnBtn").click(function(){
		location.href ="${managerPath}/column/add.do?modelId=${Session.model_id_session?default(0)}&modelTitle=${Session.model_title_session?default('')}"; 
	})
	//删除按钮
	$("#delColumnBtn").click(function(){
		//获取checkbox选中的数据
		var rows = $("#columnList").bootstrapTable("getSelections");
		//没有选中checkbox
		if(rows.length <= 0){
			<@ms.notify msg="请选择需要删除的记录" type="warning"/>
		}else{
			$(".delColumn").modal();
		}
	})
	
	$("#deleteColumnBtn").click(function(){
		var rows = $("#columnList").bootstrapTable("getSelections");
		$(this).text("正在删除...");
		$(this).attr("disabled","true");
		var ids = [];
		for(var i=0;i<rows.length;i++){
			ids[i] = rows[i].categoryId;
		}
		$.ajax({
			type: "post",
			url: "${managerPath}/${model?default("")}/column/delete.do?ids="+ids,
			dataType: "json",
			contentType: "application/json",
			success:function(msg) {
				if(msg.result == true) {
					<@ms.notify msg= "删除成功" type= "success" />
				}else {
					<@ms.notify msg= "删除失败" type= "warning" />
				}
				location.reload();
			}
		})
	});
	//查询功能
	function search(){
		var search = $("form[name='searchForm']").serializeJSON();
        var params = $('#columnList').bootstrapTable('getOptions');
        params.queryParams = function(params) {  
        	$.extend(params,search);
	        return params;  
       	}  
   	 	$("#columnList").bootstrapTable('refresh', {query:$("form[name='searchForm']").serializeJSON()});
	}
</script>