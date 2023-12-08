<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="goods" value="${goodsMap.goodsVO}" />
<c:set var="imageList" value="${goodsMap.imageList }" />
<%
	//치환 변수 선언합니다.
	//pageContext.setAttribute("crcn", "\r\n"); //개행문자
	pageContext.setAttribute("crcn", "\n"); //Ajax로 변경 시 개행 문자 
	pageContext.setAttribute("br", "<br/>"); //br 태그
%>
<html>
<head>
<style>
#layer {
	z-index: 2;
	position: absolute;
	top: 0px;
	left: 0px;
	width: 100%;
}

#popup {
	z-index: 3;
	position: fixed;
	text-align: center;
	left: 50%;
	top: 45%;
	width: 300px;
	height: 200px;
	background-color: #ccffff;
	border: 3px solid #87cb42;
}

#close {
	z-index: 4;
	float: right;
}
</style>
<script type="text/javascript">
	function add_cart(goods_id) {
		var order_qty = document.getElementById("goods_stock").value;
		
		if(${isLogOn eq false}){
			alert("로그인 후 이용 가능합니다.");
			return;
		}
		$.ajax({
			type : "post",
			async : false, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/cart/addGoodsInCart.do",
			data : {
				goods_id : goods_id,
				cart_goods_qty : order_qty

			},
			success : function(data, textStatus) {
				//alert(data);
				//	$('#message').append(data);
				if (data.trim() == 'add_success') {
					alert("상품을 장바구니에 추가하였습니다.");
				} else if (data.trim() == 'already_existed') {
					alert("이미 카트에 등록된 상품입니다.");
				}

			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다." + data);
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");
			}
		}); //end ajax	
	}

	function fn_order_each_goods(goods_id, goods_name, goods_sell_price,
			goods_image_fileName) {
		if(${isLogOn eq false}){
			alert("로그인 후 이용 가능합니다.");
			return;
		}

		var total_price, final_total_price;

		var formObj = document.createElement("form");
		var i_goods_id = document.createElement("input");
		var i_goods_name = document.createElement("input");
		var i_goods_sell_price = document.createElement("input");
		var i_goods_image_fileName = document.createElement("input");
		var i_order_goods_qty = document.createElement("input");
		
		var order_qty = document.getElementById("goods_stock").value;

		i_goods_id.name = "goods_id";
		i_goods_name.name = "goods_name";
		i_goods_sell_price.name = "goods_sell_price";
		i_goods_image_fileName.name = "goods_image_fileName";
		i_order_goods_qty.name = "order_goods_qty";

		i_goods_id.value = goods_id;
		i_order_goods_qty.value = order_qty;
		i_goods_name.value = goods_name;
		i_goods_sell_price.value = goods_sell_price;
		i_goods_image_fileName.value = goods_image_fileName;

		formObj.appendChild(i_goods_id);
		formObj.appendChild(i_goods_name);
		formObj.appendChild(i_goods_sell_price);
		formObj.appendChild(i_goods_image_fileName);
		formObj.appendChild(i_order_goods_qty);

		document.body.appendChild(formObj);
		formObj.method = "post";
		formObj.action = "${contextPath}/order/orderEachGoods.do";
		formObj.submit();
	
	}
	
</script>
</head>
<body>
	<hgroup>
		<h1>이게 뭐라고해야하나...</h1>
		<h2>ㅇㅇ &gt; ㄴㄴ &gt; ㅊㅊ</h2>
		<h3>${goods.goods_name}</h3>
	</hgroup>
	<div id="goods_image">
		<figure>
			<img alt="HTML5 &amp; CSS3"
				src="${contextPath}/thumbnails.do?goods_id=${goods.goods_id}&fileName=${goods.goods_image_fileName}">
		</figure>
	</div>



	<div id="detail_table">
		<table>
			<tbody>
				<tr>
					<td class="fixed">정가</td>
					<td class="active"><span> <fmt:formatNumber
								value="${goods.goods_price}" type="number" var="goods_price" />
							${goods_price}원
					</span></td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">판매가</td>

					<td class="active"><span> <fmt:formatNumber
								value="${goods.goods_sell_price}" type="number"
								var="discounted_price" /> ${discounted_price}원(10%할인)
					</span></td>
				</tr>
				<%-- 	<tr>
					<td class="fixed">페이지 수</td>
					<td class="fixed">${goods.goods_total_page}쪽</td>
				</tr> --%>

				<tr>
					<td class="fixed">배송료</td>
					<td class="fixed"><strong>무료</strong></td>
				</tr>
				<tr>
					<td class="fixed">배송안내</td>
					<td class="fixed"><strong>[당일배송]</strong> 당일배송 서비스 시작!<br>
						<strong>[휴일배송]</strong> 휴일에도 배송받는 aboutCat</TD>
				</tr>
				<tr>
					<td class="fixed">도착예정일</td>
					<td class="fixed">지금 주문 시 내일 도착 예정</td>
				</tr>
				<tr>
					<td class="fixed">수량</td>
					<td class="fixed"><select style="width: 60px;"
						id="goods_stock">
							<option>1</option>
							<option>2</option>
							<option>3</option>
							<option>4</option>
							<option>5</option>
					</select></td>
				</tr>
			</tbody>
		</table>
		<ul>

			<li><a class="buy"
				href="javascript:fn_order_each_goods('${goods.goods_id }','${goods.goods_name }','${goods.goods_sell_price}','${goods.goods_image_fileName}');">구매하기
			</a></li>
			<li><a class="cart"
				href="javascript:add_cart('${goods.goods_id }')">장바구니</a></li>
			<li><a class="wish" href="#">위시리스트</a></li>
		</ul>
	</div>



	<div class="clear"></div>
	<!-- 내용 들어 가는 곳 -->
	<div id="container">
		<ul class="tabs">
			<li><a href="#tab1">판매처</a></li>
			<li><a href="#tab2">리뷰</a></li>

		</ul>
		<div class="tab_container">
			<div class="tab_content" id="tab1">
				<h4>상품 소개</h4>
				<%-- 	<p>${fn:replace(goods.goods_description)}</p> --%>
				<c:forEach var="image" items="${imageList }">
					<img
						src="${contextPath}/download.do?goods_id=${goods.goods_id}&fileName=${image.goods_image_fileName}">
				</c:forEach>
			</div>
			<div class="tab_content" id="tab1">

				<div class="writer">판매처 : 어바웃캣</div>
			</div>
			<div class="tab_content" id="tab2">
				<h4>리뷰</h4>
			</div>
		</div>
	</div>




</body>
</html>
<input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}" />