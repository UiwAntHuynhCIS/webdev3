<?php require 'data.php'; ?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>TFT Team Builder</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div id="stage">
  <h1>TFT Team Builder</h1>
  <div id="pool">
    <?php foreach ($characters as $c): ?>
      <div class="slot"><img class="champ" src="img/<?= $c ?>.png" data-name="<?= $c ?>" alt="<?= $c ?>" title="<?= $c ?>" draggable="false"></div>
    <?php endforeach; ?>
  </div>

  <div id="controls">
    <button id="resetBtn">Reset</button>
    <button id="showBtn">Show</button>
    <fieldset>
      <legend>Exclude origins</legend>
      <?php foreach (array_keys($originTraits) as $o): ?>
        <label><input type="checkbox" class="excl" value="<?= $o ?>"> <?= $o ?></label>
      <?php endforeach; ?>
    </fieldset>
    <button id="excludeBtn">Exclude</button>
  </div>

  <div id="team-zone"><span>Drag champions here</span></div>
  <pre id="output"></pre>

  <div id="saveBar">
    <input id="compName" maxlength="60" placeholder="Comp name">
    <button id="saveBtn">Save comp</button>
    <span id="msg"></span>
  </div>
  <h2>Saved comps</h2>
  <ul id="comps"></ul>
</div>
<script src="js/app.js"></script>
</body>
</html>
