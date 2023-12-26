package com.itwillbs.c5d2308t1.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.c5d2308t1.mapper.MoviesMapper;
import com.itwillbs.c5d2308t1.vo.MoviesVO;
import com.itwillbs.c5d2308t1.vo.ReviewBoardVO;

@Service
public class MoviesService {
	@Autowired
	MoviesMapper mapper;
	
	// DB에 저장된 영화 목록 리스트 조회 작업 요청
	public List<Map<String, String>> getMovieList(int sortType) {
		return mapper.selectMoviesList(sortType);
	}

	// 요청한 movie_id에 해당하는 영화정보 조회 작업 요청
	public HashMap<String, String> getMovieDetail(int movie_id) {
		return mapper.selectMovieDetail(movie_id);
	}
//	//리뷰 글 작성
//	public int reviewBoard(ReviewBoardVO review1) {
//		return mapper.insertReviewBoard(review1);
//	}
	
	
	
	// 자바 코드로 API 정보 가져오는 테스트 ============================

	// List 객체 전달과 ON DUPLICATE KEY UPDATE 테스트
	public int registMovieCd(List<MoviesVO> movies) {
		return mapper.upsertMovieCd(movies);
	}
	// 모든 영화 가져오기
	public List<MoviesVO> getAllMovie() {
		return mapper.selectAllMovie();
	}
	
	public int insertMovie(MoviesVO movie) {
		System.out.println("insertMovie");
		return mapper.insertMovie(movie);
	}

	public ReviewBoardVO getreview1(ReviewBoardVO review1) {
		return mapper.selectReview(review1);
	}


}
