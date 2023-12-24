package com.itwillbs.c5d2308t1.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.ui.Model;

import com.itwillbs.c5d2308t1.vo.MoviesVO;
import com.itwillbs.c5d2308t1.vo.ReviewsVO;

@Mapper
public interface MoviesMapper {
	
	
	// DB에 저장된 영화 목록 리스트 조회 작업
	List<Map<String, String>> selectMoviesList(int sortType);

	// 요청한 movie_id에 해당하는 영화정보 조회 작업 요청
	HashMap<String, String> selectMovieDetail(String movie_id);
	

	// 자바 코드로 API 정보 가져오는 테스트 ============================
	// List 객체 전달과 ON DUPLICATE KEY UPDATE 테스트
	int upsertMovieCd(List<MoviesVO> movies);

	// 모든 영화 가져오기
	List<MoviesVO> selectAllMovie();
	int insertMovieReview(ReviewsVO review);

	int insertMovie(MoviesVO movie);
	
}
