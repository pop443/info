/**
 * 浏览器对象
 */
window.CFG = window.CFG || {};
CFG.CFun = {};


CFG.Client = function(){
	this.ready = "0" ;
};


/*
 * 滚动条在Y轴上的滚动距离
 */
CFG.Client.prototype.getScrollTop = function(){
	var scrollTop = 0;
	var bodyScrollTop = 0;
	var documentScrollTop = 0;
	if (document.body) {
		bodyScrollTop = document.body.scrollTop;
	}
	;
	if (document.documentElement) {
		documentScrollTop = document.documentElement.scrollTop;
	}
	;
	scrollTop = (bodyScrollTop - documentScrollTop > 0) ? bodyScrollTop
			: documentScrollTop;
	return scrollTop;
};
/*
 * 文档的总高度
 */
CFG.Client.prototype.getScrollHeight = function(){
	var scrollHeight = 0, bodyScrollHeight = 0, documentScrollHeight = 0;
	if (document.body) {
		bodyScrollHeight = document.body.scrollHeight;
	}
	if (document.documentElement) {
		documentScrollHeight = document.documentElement.scrollHeight;
	}
	scrollHeight = (bodyScrollHeight - documentScrollHeight > 0) ? bodyScrollHeight
			: documentScrollHeight;
	return scrollHeight;
};
/*
 * 浏览器视口的高度
 */
CFG.Client.prototype.getWindowHeight = function(){
	var windowHeight = 0;
	if (document.compatMode == "CSS1Compat") {
		windowHeight = document.documentElement.clientHeight;
	} else {
		windowHeight = document.body.clientHeight;
	}
	return windowHeight;
};
/**
 * 判断 视口距离底部是否在给定高度之内
 * @param height
 * @returns {Boolean}
 */
CFG.Client.prototype.isScroll = function(height){
	if(this.getScrollTop() + this.getWindowHeight() > this.getScrollHeight()-height){
		return true ;
	}
	return false ;
};

