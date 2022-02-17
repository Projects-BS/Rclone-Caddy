<?php 

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_FILES['files'])) {
        $errors = [];
        $msgs = [];
        if (!file_exists('tmp')) {
    mkdir('/home/hirun/.config/rclonef/', 0777, true);
}
        $path = '/home/hirun/.config/rclonef/';
	$extensions = ['conf'];
		
        $all_files = count($_FILES['files']['tmp_name']);

        for ($i = 0; $i < $all_files; $i++) {  
		$file_name = $_FILES['files']['name'][$i];
		$file_tmp = $_FILES['files']['tmp_name'][$i];
		$file_type = $_FILES['files']['type'][$i];
		$file_size = $_FILES['files']['size'][$i];
		$tmp = explode('.', $_FILES['files']['name'][$i]);
		$file_ext = strtolower(end($tmp));

		$file = $path . $file_name;

		if (!in_array($file_ext, $extensions)) {
			$errors[] = 'File type not allowed : (' . $file_type . ')';
		}

		if ($file_size > 2097152) {
			$errors[] = 'File size exceeds limit : (' . $file_size . ')';
		}

		if (empty($errors)) {
			move_uploaded_file($file_tmp, $file);
			$msgs[] = 'File uploaded successfully!';
		}
	}
    
	$ecror=implode($errors);
	$ecsgs=implode($msgs);
	
	if ($errors)  echo $ecror;
	if ($msgs) echo $ecsgs;
    }
}
