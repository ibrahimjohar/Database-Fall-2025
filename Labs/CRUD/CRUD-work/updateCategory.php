<?php
include("php/dbcon.php");

$allowedExtensions = ["png", "svg", "jpg", "jpeg", "webp"];

function respond(string $message, string $target = "select.php"): void
{
    $message = str_replace(["\r", "\n"], "", $message);
    $message = addslashes($message);
    $target = addslashes($target);
    echo "<script>alert('{$message}');location.assign('{$target}')</script>";
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_POST['updateCategory'])) {
    respond("Invalid request");
}

$categoryId = isset($_POST['categoryId']) ? (int)$_POST['categoryId'] : 0;
$categoryName = trim($_POST['cName'] ?? "");
$categoryDes = trim($_POST['cDes'] ?? "");

$errors = [];
if ($categoryId <= 0) {
    $errors[] = "Invalid category selected";
}
if ($categoryName === "") {
    $errors[] = "Category Name is Required";
}
if ($categoryDes === "") {
    $errors[] = "Category Description is Required";
}

$categoryQuery = $pdo->prepare("select image from categories where id = :catId");
$categoryQuery->bindParam(":catId", $categoryId, PDO::PARAM_INT);
$categoryQuery->execute();
$category = $categoryQuery->fetch(PDO::FETCH_ASSOC);
if (!$category) {
    $errors[] = "Category not found";
}

$existingImage = $category["image"] ?? "";
$imageToSave = $existingImage;

$fileUpload = $_FILES["cImage"] ?? null;
$hasNewImage = $fileUpload && $fileUpload["error"] !== UPLOAD_ERR_NO_FILE;
if ($hasNewImage) {
    if ($fileUpload["error"] !== UPLOAD_ERR_OK) {
        $errors[] = "Image upload failed";
    } else {
        $extension = strtolower(pathinfo($fileUpload["name"], PATHINFO_EXTENSION));
        if (!in_array($extension, $allowedExtensions, true)) {
            $errors[] = "Invalid Extension";
        } else {
            $newImageName = uniqid("cat_", true) . "." . $extension;
            $destination = __DIR__ . DIRECTORY_SEPARATOR . "images" . DIRECTORY_SEPARATOR . $newImageName;
            if (!move_uploaded_file($fileUpload["tmp_name"], $destination)) {
                $errors[] = "Failed to save image";
            } else {
                if ($existingImage) {
                    $oldImage = __DIR__ . DIRECTORY_SEPARATOR . "images" . DIRECTORY_SEPARATOR . $existingImage;
                    if (file_exists($oldImage)) {
                        unlink($oldImage);
                    }
                }
                $imageToSave = $newImageName;
            }
        }
    }
}

if ($errors) {
    respond(implode(" | ", $errors), "editCategory.php?cId={$categoryId}");
}

$updateQuery = $pdo->prepare("update categories set name = :cName, des = :cDes, image = :cImage where id = :cId");
$updateQuery->bindParam(":cName", $categoryName);
$updateQuery->bindParam(":cDes", $categoryDes);
$updateQuery->bindParam(":cImage", $imageToSave);
$updateQuery->bindParam(":cId", $categoryId, PDO::PARAM_INT);
$updateQuery->execute();

respond("category updated successfully");

