#!usr/bin/env roseus

(ros::roseus "homework1022")

(defun 1_1 (num)
  (dotimes (i num)
    (format t  "."))
  (format t "~%")
  )

(defun 1_2 (num)
  (if (< num 1)
      nil
    (progn (format t ".")
	   (1_2 (- num 1)))
    )
  )

(defun 2_1 (argv)
  (setq cnt 0)
  (while (not (null argv))
	 (if (equal (quote a) (car argv))
	     (setq cnt (+ cnt 1))
	   nil)
	 (setq argv (cdr argv))
	 )
  (format t "The number of a : ~A~%" cnt)
  )

(defun 2_2 (argv)
  (setq cnt 0)
  (if (null argv)
      0
    (if (equal (quote a) (car argv))
	(setq cnt (+ 1 (2_2 (cdr argv))))
      (setq cnt (2_2 (cdr argv)))
      )
    )
  )

(defun summit (lst)
  (setq lst (remove nil lst))
  ;;remove は非破壊的な関数であるため、lstの内容を変更しない。removeの返り値を新たにlstに代入しておく必要がある。
  (apply #'+ lst))

(defun summit2 (lst)
  (let ((x (car lst)))
    (if (null x)
	(if (not (null (cdr lst)))
	(summit2 (cdr lst))
	0);;lstの内容をすべて精査し終わったら再帰をやめるようにしておかないと無限ループにはまってコアダンプする。
      (+ x (summit2 (cdr lst))))))