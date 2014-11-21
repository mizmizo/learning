#!/usr/bin/env roseus

(ros::roseus "joy_controller")
(ros::advertise "/cmd_vel" geometry_msgs::Twist 1)

(setq *vel_msg* (instance geometry_msgs::Twist :init))

(load "package://hrpsys_ros_bridge_tutorials/euslisp/hrp2w-interface.l")
(hrp2w-init)
(objects *hrp2w*)

(defun cmd_callback (msg)
  (format t "axes: ~A~%" (send msg :axes))
  (format t "buttons: ~A~%" (send msg :buttons))
  (setq buttons (send msg :buttons))
  (setq axes (send msg :axes))
  (if (= (elt buttons 10) 1)
      (progn
	(print "a")
	(setq x (* (elt axes 1) 0.1))
	(setq y (* (elt axes 0) 0.1))
	(setq z (* (elt axes 2) 0.1))
	(cond
	 ((= (elt buttons 12) 1)
	  (progn
	    (setq x 0)
	    (setq y 0)
	    (setq z 0)
	    (send *hrp2w* :reset-pose)
	    (send *ri* :angle-vector (send *hrp2w* :angle-vector) 4000)
	    (send *ri* :wait-interpolation)
	    ))
	 ((= (elt buttons 14) 1)
	  (progn
	    (setq x 0)
	    (setq y 0)
	    (setq z 0)
	    (send *hrp2w* :reset-manip-pose)
	    (send *ri* :angle-vector (send *hrp2w* :angle-vector) 4000)
	    (send *ri* :wait-interpolation)
	    ))
	 ((= (elt buttons 13) 1)
	  (progn
	    (setq x 0)
	    (setq y 0)
	    (setq z 0)
	    (send *hrp2w* :head :look-at (send *hrp2w* :rarm :end-coords :pos))
	    (send *ri* :angle-vector (send *hrp2w* :angle-vector) 2000)
	    (send *ri* :wait-interpolation)
	    ))
	 ((= (elt buttons 15) 1)
	  (progn
	    (setq x 0)
	    (setq y 0)
	    (setq z 0)
	    (send *hrp2w* :head :look-at (send *hrp2w* :larm :end-coords :pos))
	    (send *ri* :angle-vector (send *hrp2w* :angle-vector) 2000)
	    (send *ri* :wait-interpolation)
	    ))
	 )
	)
    (progn
      (print "b")
      (setq x 0)
      (setq y 0)
      (setq z 0))
    )
  (send *vel_msg* :linear :x x)
  (send *vel_msg* :linear :y y)
  (send *vel_msg* :angular :z z)
  (ros::publish "/cmd_vel" *vel_msg*)
  )

(ros::subscribe "/joy" sensor_msgs::Joy #'cmd_callback)

(do-until-key
 (ros::spin-once)
 (ros::publish "/cmd_vel" *vel_msg*)
 )