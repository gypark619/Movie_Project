package com.itwillbs.c5d2308t1.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.c5d2308t1.vo.CsVO;

@Mapper
public interface CsMapper {
	

	// 고객센터 문의글 등록 - 추상메서드 정의
	int insertBoard(CsVO cs);
	
	// 고객센터 메인에 자주묻는질문과 공지사항 출력
	List<CsVO> selectFaqMainList();
	List<CsVO> selectNoticeMainList();
	
	// 고객센터 자주묻는질문 조회 - 추상메서드 정의
	List<CsVO> selectFaqList(@Param("startRow") int startRow, @Param("listLimit") int listLimit);
	
	// 자주묻는질문 세부항목별 조회 - 추상메서드 정의
	List<CsVO> selectFaqDetail(String buttonName);
	
	// 자주묻는질문 검색
	List<CsVO> selectFaqSearch(@Param("searchValue") String searchValue);
	
	// 고객센터 자주묻는질문 갯수 조회 - 추상메서드 정의
	Integer selectFaqListCount();
	
	// 고객센터 공지사항 조회 - 추상메서드 정의
	List<CsVO> selectNoticeList(@Param("startRow") int startRow, @Param("listLimit") int listLimit);

	// 고객센터 공지사항 갯수 조회 - 추상메서드 정의
	Integer selectNoticeListCount();

	// 고객센터 검색
	List<CsVO> selectNoticeSearch(@Param("theater_id") String theater_id, @Param("searchValue") String searchValue);




}
