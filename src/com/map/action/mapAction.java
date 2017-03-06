package com.map.action;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.lang3.StringUtils;
import org.jdom.JDOMException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.xml.sax.SAXException;
import com.map.entity.coordDto;
import com.map.util.JsonVo;
import com.map.util.fileUtil;

import net.sf.json.JSONArray;

/**
 * 地图轨迹
 * @author Arthur
 */
@Controller
public class mapAction {
	
	
	/**
	 * 跳转到地图
	 */
	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/toBaiduMap",method=RequestMethod.GET)
	public ModelAndView toBaiduMap(HttpServletRequest request,HttpServletResponse response){
		ModelAndView modelAndView = new ModelAndView();
		List<coordDto> coordList = new ArrayList<>();
		String path = request.getRealPath("/upload");
		File dir = new File(path);
		String[] children = dir.list();
		String names="";
		if (children.length==0) {
	         System.out.println("该目录不存在");
	     }else{
		    	 for (int i = 0; i < children.length; i++) {
		                String filename = children[i];
		                names +=filename.substring(0,  filename.lastIndexOf("."))+",";
		                try {
		                	coordList.addAll(fileUtil.readXmlDoc(path+"/"+filename,filename));
						} catch (FileNotFoundException e) {
							e.printStackTrace();
						} catch (JDOMException e) {
							e.printStackTrace();
						} catch (IOException e) {
							e.printStackTrace();
						}
		       }
	     }
		Collections.sort(coordList,new Comparator<coordDto>(){
			@Override
			public int compare(coordDto o1, coordDto o2) {
				return Integer.parseInt(o1.getSort())-Integer.parseInt(o2.getSort());
			}
		});
		modelAndView.addObject("coorList",JSONArray.fromObject(coordList));
		modelAndView.addObject("name", names);
		modelAndView.setViewName("/test");
		return  modelAndView;  
	}

	/**
	 * 保存轨迹
	 */
	@ResponseBody
	@SuppressWarnings({ "deprecation", "rawtypes" })
	@RequestMapping(value = "/doSavePath",method=RequestMethod.POST)
	public  JsonVo savePath(HttpServletRequest request,HttpServletResponse response){
		JsonVo  jsonVo = new JsonVo();
		String coord = request.getParameter("coord");
		String name = request.getParameter("name");
		String sort = request.getParameter("sort");
		coordDto coordDtos = new coordDto();
		if(!StringUtils.isBlank(coord)){
			String [] arrXY = coord.split(",");
			String val = "";
			for (String str : arrXY) {
				val +=str.replaceAll(":", ",")+"&";
			}
			coordDtos.setCoord(val);
			coordDtos.setSort(sort);
			String path = request.getRealPath("/upload")+"/"+name+".xml";
			try {
				fileUtil.createXmlDoc(coordDtos, path);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return jsonVo;
	}
	
	/**
	 * 读取内容
	 */
	@ResponseBody
	@SuppressWarnings({ "rawtypes", "unchecked", "deprecation" })
	@RequestMapping(value = "/doReadMap",method=RequestMethod.POST)
	public JsonVo readMap(HttpServletRequest request,HttpServletResponse response){
		JsonVo  jsonVo = new JsonVo();
		String name = request.getParameter("name");
		String path = request.getRealPath("/upload");
		path = path+"/"+name+".xml";
		List<coordDto> coordList = null;
		try {
			coordList = fileUtil.readXmlDoc(path,name);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (JDOMException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		String[] arrCon;
		String [] arrNext ;
		String[] arrEnd;
		coordDto coorddto =null;
		List<coordDto> coordList1 = new ArrayList<>();
		if(coordList.size()>0){
			for (int i = 0; i < coordList.size(); i++) {
				arrCon = coordList.get(i).getCoord().split("&");
				if (arrCon.length>0) {
					for (int j = 0; j < arrCon.length; j++) {
						arrNext = arrCon[j].split(",");
						if(arrNext.length>0){
							for (int x= 0; x< arrNext.length; x++) {
								arrEnd = arrNext[x].split(":");
								for(int z =0;z<arrEnd.length-1;z++){
									coorddto = new coordDto();
									coorddto.setLng(arrEnd[z]);
									coorddto.setLat(arrEnd[z+1]);
									coordList1.add(coorddto);
								}
							}
						}
					}
				}
			}
		}
		jsonVo.setResult(coordList1);
		return jsonVo;
	}
	
	
	/**
	 * 删除轨迹
	 * @return
	 */
	@ResponseBody
	@SuppressWarnings({ "rawtypes", "unchecked", "deprecation" })
	@RequestMapping(value = "/doDeleteMap",method=RequestMethod.POST)
	public JsonVo deleteMap(HttpServletRequest request,HttpServletResponse response){
		JsonVo  jsonVo = new JsonVo();
		String name = request.getParameter("name");
		String path = request.getRealPath("/upload");
		path = path+"/"+name+".xml";
		jsonVo.setResult(fileUtil.deleteFile(path));
		 return jsonVo;
	}
	
	/**
	 * 修改节点信息
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@SuppressWarnings({ "rawtypes", "deprecation", "unchecked" })
	@RequestMapping(value = "/doUpdateMap",method=RequestMethod.POST)
	public JsonVo updateMap(HttpServletRequest request,HttpServletResponse response){
		JsonVo jsonVo = new JsonVo();
		String name = request.getParameter("name");
		String trackname = request.getParameter("trackname");
		String describe = request.getParameter("describe");
		String coord = request.getParameter("coord");
		coordDto coordDto = new coordDto();
		coordDto.setDescribe(describe);
		coordDto.setName(trackname);
		coordDto.setCoord(coord);
		coordDto.setId(name);
		String path = request.getRealPath("/upload");
		path = path+"/"+name+".xml";
		try {
			jsonVo.setSuccess(fileUtil.updateXmlDoc(path,coordDto));
			jsonVo.setResult(coordDto);
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return jsonVo;
	}
	
}
