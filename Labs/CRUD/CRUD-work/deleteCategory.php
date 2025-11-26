<?php
include("php/dbcon.php");

function respond(string $message, string $target = "select.php"): void
{
    $message = str_replace(["\r", "\n"], "", $message);
    $message = addslashes($message);
    $target = addslashes($target);
    echo "<script>alert('{$message}');location.assign('{$target}')</script>";
    exit;
}

$categoryId = isset($_GET["cId"]) ? (int)$_GET["cId"] : 0;
if ($categoryId <= 0) {
    respond("Invalid category");
}

$categoryQuery = $pdo->prepare("select image from categories where id = :catId");
$categoryQuery->bindParam(":catId", $categoryId, PDO::PARAM_INT);
$categoryQuery->execute();
$category = $categoryQuery->fetch(PDO::FETCH_ASSOC);
if (!$category) {
    respond("Category not found");
}

$deleteQuery = $pdo->prepare("delete from categories where id = :catId");
$deleteQuery->bindParam(":catId", $categoryId, PDO::PARAM_INT);
$deleteQuery->execute();

$existingImage = $category["image"] ?? "";
if ($existingImage) {
    $imagePath = __DIR__ . DIRECTORY_SEPARATOR . "images" . DIRECTORY_SEPARATOR . $existingImage;
    if (file_exists($imagePath)) {
        unlink($imagePath);
    }
}

respond("category deleted successfully");

