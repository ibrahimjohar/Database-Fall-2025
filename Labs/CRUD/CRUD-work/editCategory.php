<?php
include("php/query.php");
$category = ['id' => '', 'name' => '', 'des' => '', 'image' => ''];
if (isset($_GET['cId'])) {
    $categoryId = $_GET['cId'];
    $query = $pdo->prepare("select * from categories where id = :catId");
    $query->bindParam("catId", $categoryId);
    $query->execute();
    $fetched = $query->fetch(PDO::FETCH_ASSOC);
    if ($fetched) {
        $category = $fetched;
    }
}
?>
<!doctype html>
<html lang="en">
  <head>
    <title>Title</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
  </head>
  <body>
            <div class="container p-5">
                <form action="updateCategory.php" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="categoryId" value="<?php echo htmlspecialchars($category['id'], ENT_QUOTES); ?>">
                    <div class="form-group">
                      <label for="">Name</label>
                      <input type="text" value="<?php echo htmlspecialchars($category['name'], ENT_QUOTES); ?>" name="cName" id="" class="form-control" placeholder="" aria-describedby="helpId">
                      <small id="helpId" class="text-danger"><?php echo $categoryNameErr?></small>
                    </div>
                    <div class="form-group">
                      <label for="">Image</label>
                      <input type="file" name="cImage" id="" class="form-control" placeholder="" aria-describedby="helpId">
                      <small id="helpId" class="text-danger"><?php echo $categoryImageNameErr?></small>
                      <?php if (!empty($category['image'])): ?>
                        <img src="images/<?php echo htmlspecialchars($category['image'], ENT_QUOTES); ?>" alt="">
                      <?php endif; ?>
                    </div>
                    <div class="form-group">
                      <label for="">Description</label>
                      <textarea name="cDes" id="" class="form-control" placeholder="" aria-describedby="helpId"><?php echo htmlspecialchars($category['des'], ENT_QUOTES); ?></textarea>
                      <small id="helpId" class="text-danger"><?php echo $categoryDesErr?></small>

                    </div>

                    <button class="btn-info btn" name="updateCategory">Update Category</button>
                </form>
            </div>
    
  </body>
</html>