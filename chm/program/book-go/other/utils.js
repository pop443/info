/**
 * 限制字符串长度，超出的以“...”表示
 * @param {Object} word
 * @param {Object} len
 */
function showTitle(word, len)
{
    if (word !== undefined && word !== null && (typeof word == "string")) 
    {
        if (word.length > len) 
        {
            word = word.substr(0, len - 1) + "…";
        }
    }
    else 
    {
        word = "";
    }
    return word;
}

/**
 * 去除字符串首尾的空格
 * @param {Object} str
 */
function trim(str)
{
    return str.replace(/(^\s*)|(\s*$)/g, "");
}
    
function isNull(str)
{
   if (str == null || str == undefined || str.length <= 0) 
   {
      return true;
   }
   return false;
}
/**
*   是否是数字 
*/
function chkNumber(str) {   
    var re = /^[\d]+$/   
    return re.test(str);   
}

/*
 * 校验是否是数字
 */
function checkIsNum(numValue) {
	try {
		var reg1 = /^[0-9]+$/;
		if (!reg1.test(numValue)) {
			return false;
		} else {
			return true;
		}
	} catch (e) {
		return false;
	}
}

/**
 * 校验密码是否为6位数字
 * @param {Object} value
 */
function chkUserPwd(value)
{
    var pattern = /^([0-9]){6}/;
    return pattern.test(value);
}

/**
 * 校验验证码前四位是否为数字和字符串混合
 * @param {Object} value
 */
function chkVerifyCode(value)
{
    var pattern = /[0-9a-zA-Z]{4}/;
    return pattern.test(value);
}

//将日期转换为数字格式
function convertToNumber(str){
    var result = "";
    if(str != null && str != undefined){
        var result = str.replace(new RegExp("-* *\:*\/*","gm"),"");
    }
    return result ;
}

//转换html特殊字符 显示
function converHTML(str){
    var tmpStr = str ;
    if(tmpStr != null && tmpStr != undefined){
        tmpStr = tmpStr.replace(/</g,"&lt;");
        tmpStr = tmpStr.replace(/>/g,"&gt;");
        tmpStr = tmpStr.replace(/&/g,"&amp;");
        tmpStr = tmpStr.replace(/\"/g,"&quot;");
        tmpStr = tmpStr.replace(/©/g,"&copy;");
        tmpStr = tmpStr.replace(/®/g,"&reg;");
        tmpStr = tmpStr.replace(/×/g,"&times;");
        tmpStr = tmpStr.replace(/÷/g,"&divide;");        
    }
    return tmpStr ;
}
//字符实体转换为html字符
function translateHTML(str){
    var tmpStr = str ;
    if(tmpStr != null && tmpStr != undefined){
        tmpStr = tmpStr.replace(/&lt;/g,"<");
        tmpStr = tmpStr.replace(/&gt;/g,">");
        tmpStr = tmpStr.replace(/&amp;/g,"&");
        tmpStr = tmpStr.replace(/&quot;/g,"\"");
        tmpStr = tmpStr.replace(/&copy;/g,"©");
        tmpStr = tmpStr.replace(/&reg;/g,"®");
        tmpStr = tmpStr.replace(/&times;/g,"×");
        tmpStr = tmpStr.replace(/&divide;/g,"÷");        
    }
    return tmpStr ;
}

function isEmail(strEmail){
	var patn = /^[_a-zA-Z0-9\-]+(\.[_a-zA-Z0-9\-]*)*@[a-zA-Z0-9\-]+([\.][a-zA-Z0-9\-]+)+$/;
	if(patn.test(strEmail)){
		return true;
	}else{
		return false;
	}
 }

/*
 * 校验是否存在特殊字符
 *
 * @author maofw
 */
function checkSpecialChar(str) {
	try {
		var regStr = /[`~@#$%^*\/\\<>\|&\'\"]/;
		var re = new RegExp(regStr);
		if (re.test(str)) {
			return true;
		} else {
			return false;
		}
	} catch (e) {
		return false;
	}
}

//过滤首尾空格
String.prototype.trim = function () {
	try {
		var regStr = /^\s*|\s*$/g;
		var reg = new RegExp(regStr);
		return this.replace(regStr, "");
	}
	catch (e) {
		return this;
	}
}
//map
function Map() {
	  
    this.elements = new Array();   
  
    this.size = function() {   
        return this.elements.length;   
    }   
  
    this.isEmpty = function() {   
        return (this.elements.length < 1);   
    }   
  
    this.clear = function() {   
        this.elements = new Array();   
    }   
  
    this.put = function(_key, _value) {   
        this.elements.push({key:_key, value:_value});   
    }   
  
    this.remove = function(_key) {   
        var bln = false;   
  
        try {   
            for (i = 0; i < this.elements.length; i++) {   
                if (this.elements[i].key == _key) {   
                    this.elements.splice(i, 1);   
                    return true;   
                }   
            }   
        } catch(e) {   
            bln = false;   
        }   
        return bln;   
    }   
  
    this.get = function(_key) {   
        try{    
            for (i = 0; i < this.elements.length; i++) {   
                if (this.elements[i].key == _key) {   
                    return this.elements[i].value;   
                }   
            }   
        }catch(e) {   
            return null;   
        }   
    }   
  
    this.element = function(_index) {   
        if (_index < 0 || _index >= this.elements.length) {   
            return null;   
        }   
        return this.elements[_index];   
    }   
  
    this.containsKey = function(_key) {   
        var bln = false;   
        try {   
            for (i = 0; i < this.elements.length; i++) {   
                if (this.elements[i].key == _key) {   
                    bln = true;   
                }   
            }   
        }catch(e) {   
            bln = false;   
        }   
        return bln;   
    }   
  
    this.containsValue = function(_value) {   
        var bln = false;   
        try {   
            for (i = 0; i < this.elements.length; i++) {   
                if (this.elements[i].value == _value){   
                    bln = true;   
                }   
            }   
        } catch(e) {   
            bln = false;   
        }   
        return bln;   
    }   
  
    this.values = function() {   
        var arr = new Array();   
        for (i = 0; i < this.elements.length; i++) {   
            arr.push(this.elements[i].value);   
        }   
        return arr;   
    }   
  
    this.keys = function() {   
        var arr = new Array();   
        for (i = 0; i < this.elements.length; i++) {   
            arr.push(this.elements[i].key);   
        }   
        return arr;   
    }   
}


//转日期格式: return  2007-01-01 18:01:01 234
//typeId: 0 格式:2007-01-01 18:01:01 234
//typeId: 1 格式:2007年1月1日 18点01分01秒 234毫秒
function getFormatNormal(time,typeId)
{
  var timeValue = trim(time);    
  if (isNull(timeValue)) 
  { 
    return formatTime;  
  }
 
  if (typeId == '0')
  {         
    return getFormatNormalEn(timeValue);    
  } 
  else 
  {
    return getFormatNormalChina(timeValue);
  }    
}
    
//typeId: 0 格式:2007-01-01 18:01:01 234
function getFormatNormalEn(timeValue)
{
   var formatTime = '';
   if (timeValue.length == 4)
  {
     //MMdd to mm - dd
    formatTime = timeValue.substring(0,2) + "-" + timeValue.substring(2,4);
  } else if (timeValue.length == 6) {
    //yyyyMM to yyyy - mm
    formatTime = timeValue.substring(0,4) + "-" + timeValue.substring(4,6);
  } else if (timeValue.length == 8) {
     //yyyyMMdd to yyy - mm - dd 
    formatTime = timeValue.substring(0,4) + "-" + timeValue.substring(4,6) +  "-" + timeValue.substring(6,8); 
  } else if (timeValue.length == 12) {
      //yyyyMMddhhmi to yyyy-mm-dd hh:mi
      formatTime = timeValue.substring(0,4) + "-" + timeValue.substring(4,6) +  "-" + timeValue.substring(6,8); 
      formatTime += ' ' + timeValue.substring(8,10) + ':' + timeValue.substring(10,12);
  } else if (timeValue.length == 14) {   
      //yyyyMMddhhmiss to yyyy - mm - dd hh:mi:ss
      formatTime = timeValue.substring(0,4) + "-" + timeValue.substring(4,6) +  "-" + timeValue.substring(6,8); 
      formatTime += ' ' + timeValue.substring(8,10) + ':' + timeValue.substring(10,12) + ':' + timeValue.substring(12,14);
  }else if (timeValue.length == 17) {
      //yyyyMMddhhmissS to yyyy-mm-dd hh:mi:ss S
      formatTime = timeValue.substring(0,4) + "-" + timeValue.substring(4,6) +  "-" + timeValue.substring(6,8); 
      formatTime += ' ' + timeValue.substring(8,10) + ':' + timeValue.substring(10,12) + ':' + timeValue.substring(12,14);       
  } else {
     formatTime = timeValue;
  }	
  return  formatTime;    
}
    
//typeId: 1 格式:2007年1月1日 18点01分01秒 234毫秒
function getFormatNormalChina(timeValue)
{ 
   var formatTime = '';
   if (timeValue.length == 4)
  {
     //MMdd to mm 月 dd 日
     formatTime = timeValue.substring(0,2) + "月" + timeValue.substring(2,4) + '日';
  } else if (timeValue.length == 6) {
    //yyyyMM to yyyy - mm
    formatTime = timeValue.substring(0,4) + "年" + timeValue.substring(4,6) + '月';
  } else if (timeValue.length == 8) {
     //yyyyMMdd to yyy - mm - dd 
    formatTime = timeValue.substring(0,4) + "年" + timeValue.substring(4,6) +  "月" + timeValue.substring(6,8) + '日'; 
  } else if (timeValue.length == 12) {
      //yyyyMMddhhmi to yyyy-mm-dd hh:mi
      formatTime = timeValue.substring(0,4) + "年" + timeValue.substring(4,6) +  "月" + timeValue.substring(6,8) + '日'; 
      formatTime += ' ' + timeValue.substring(8,10) + '时' + timeValue.substring(10,12) + '分';
  } else if (timeValue.length == 14) {   
      //yyyyMMddhhmiss to yyyy - mm - dd hh:mi:ss
      formatTime = timeValue.substring(0,4) + "年" + timeValue.substring(4,6) +  "月" + timeValue.substring(6,8) + '日';  
      formatTime += ' ' + timeValue.substring(8,10) + '时' + timeValue.substring(10,12) + '分' + timeValue.substring(12,14) + '秒';
  }else if (timeValue.length == 17) {
      //yyyyMMddhhmissS to yyyy-mm-dd hh:mi:ss S
      formatTime = timeValue.substring(0,4) + "年" + timeValue.substring(4,6) +  "月" + timeValue.substring(6,8) + '日';  
      formatTime += ' ' + timeValue.substring(8,10) + '时' + timeValue.substring(10,12) + '分' + timeValue.substring(12,14) + '秒';     
  } else {
     formatTime = timeValue;
  }
  return formatTime;
}
