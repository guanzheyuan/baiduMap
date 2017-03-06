package com.map.entity;
/**
 * 坐标实体类
 * @author Arthur
 *
 */
public class coordDto {

	public String lng;
	public String lat;
	public String name;
	public String describe;
	public String distance;
    public String coord;
    public String id;
    public String sort;
	public coordDto(){}
	public coordDto(String name,String describe,String distance,String coord){
		this.name = name;
		this.describe = describe;
		this.distance = distance;
		this.coord = coord;
	}
	
	
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCoord() {
		return coord;
	}
	public void setCoord(String coord) {
		this.coord = coord;
	}
	public String getLng() {
		return lng;
	}
	public void setLng(String lng) {
		this.lng = lng;
	}
	public String getLat() {
		return lat;
	}
	public void setLat(String lat) {
		this.lat = lat;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescribe() {
		return describe;
	}
	public void setDescribe(String describe) {
		this.describe = describe;
	}
	public String getDistance() {
		return distance;
	}
	public void setDistance(String distance) {
		this.distance = distance;
	}
}
