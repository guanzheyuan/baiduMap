package com.map.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import javax.xml.parsers.ParserConfigurationException;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.xml.sax.SAXException;
import com.map.entity.coordDto;


public class fileUtil {

	/**
	 * 创建文件
	 */
	public static void writeTxt(String context,String path){
		File file = new File(path);
		try {
			file.createNewFile();
			Writer out = new FileWriter(file,true);
			out.write(context);
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 读取txt文件内容
	 * @param filePath
	 * @return
	 */
	public static String readFile(String filePath){
		String content = "";
		 try {
             String encoding="GBK";
             File file=new File(filePath);
             if(file.isFile() && file.exists()){ //判断文件是否存在
	                 InputStreamReader read = new InputStreamReader(
	                 new FileInputStream(file),encoding);//考虑到编码格式
	                 BufferedReader bufferedReader = new BufferedReader(read);
	                 String lineTxt = null;
	                 while((lineTxt = bufferedReader.readLine()) != null){
	                	 	content = lineTxt;
	                 }
	                 read.close();
			     }else{
			         System.out.println("找不到指定的文件");
			     }
	     } catch (Exception e) {
	         System.out.println("读取文件内容出错");
	         e.printStackTrace();
	     }
		 return content;
	}
	
	/**
	 * 删除文件
	 */
	public static boolean deleteFile(String path){
		boolean flag = false;
		File file = new File(path);
		 if (file.isFile() && file.exists()) {  
		        file.delete(); 
		        flag = true;
		  }
		 return flag;
	}
	/**
	 * 创建xml文件
	 */
	public static void createXmlDoc(coordDto coorddto,String path) throws FileNotFoundException, IOException{
		 // 创建根节点 并设置它的属性 ;     
        Element root = new Element("Employees"); 
        // 将根节点添加到文档中；     
        Document Doc = new Document(root); 
        	 // 创建节点 map;     
         Element elements = new Element("Employee");       
        // 给 map 节点添加子节点并赋值；     
         root.addContent(elements);    
         Element name=new Element("name");
         name.setText(coorddto.getName());
         elements.addContent(name);
         Element describe=new Element("describe");
         describe.setText(coorddto.getDescribe());
         elements.addContent(describe);
         Element distance=new Element("distance");
         distance.setText(coorddto.getDistance());
         elements.addContent(distance);
         Element coord=new Element("coord");
         coord.setText(coorddto.getCoord());
         elements.addContent(coord);
         Element sort=new Element("sort");
         sort.setText(coorddto.getSort());
         elements.addContent(sort);
        XMLOutputter XMLOut = new XMLOutputter(FormatXML()); 
        XMLOut.output(Doc, new FileOutputStream(path));  
	}
	public static Format FormatXML(){    
        //格式化生成的xml文件   
        Format format = Format.getCompactFormat();    
        format.setEncoding("utf-8");    
        format.setIndent(" ");    
        return format;    
    } 
	/**
	 * 修改节点
	 */
	@SuppressWarnings("unchecked")
	public static boolean updateXmlDoc(String path,coordDto coordDto) throws ParserConfigurationException, SAXException, IOException{
		SAXBuilder saxBuilder = new SAXBuilder();
		Document document = null;
		boolean flag = true;
		try {
			 document = saxBuilder.build(new File(path));
			 Element rootElement = document.getRootElement();
			 List<Element> listEmpElement = rootElement.getChildren("Employee");
			//loop through to edit every Employee element
		        for (Element empElement : listEmpElement) {
		        		//change the name to BLOCK letters
		            empElement.getChild("name").setText(coordDto.getName());
		            empElement.getChild("describe").setText(coordDto.getDescribe());
		            empElement.getChild("coord").setText(coordDto.getCoord());
		        }
		        XMLOutputter XMLOut = new XMLOutputter(FormatXML()); 
		        XMLOut.output(document, new FileOutputStream(path));  
		} catch (JDOMException e) {
			e.printStackTrace();
			flag = false;
		}
		return  flag;
	}
	/**
	 * 读取xml文件
	 * @throws IOException 
	 * @throws JDOMException 
	 * @throws FileNotFoundException 
	 */
	@SuppressWarnings("unchecked")
	public static List<coordDto> readXmlDoc(String path,String id) throws FileNotFoundException, JDOMException, IOException{
		 SAXBuilder saxBuilder = new SAXBuilder();//建立构造器  
		 Document doc = saxBuilder.build(new File(path));//读入指定文件  
	     Element root = doc.getRootElement();//获得根节点  
	     List<Element> listEmpElement = root.getChildren("Employee");
	     coordDto coorddto = new coordDto();
	     List<coordDto> coorList = new ArrayList<>();
	     for (Element empElement : listEmpElement) {
		    	 coorddto.setName(empElement.getChild("name").getText());
		    	 coorddto.setDescribe(empElement.getChild("describe").getText());
		    	 if(id.lastIndexOf(".")>0){
		    	 	 coorddto.setId(id.substring(0, id.lastIndexOf(".")));
		    	 }else{
		    	 	 coorddto.setId(id);
		    	 }
		    	 coorddto.setCoord(empElement.getChild("coord").getText());
		    	 coorddto.setSort(empElement.getChild("sort").getText());
		    	 coorList.add(coorddto);
	     }
	     return coorList;
	}
}
