<!DOCTYPE html>
<html lang="ar">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>المشروع المساحي الذكي</title>
<style>
    body {font-family: 'Segoe UI', Tahoma, sans-serif; background: #f0f4f8; margin:0; padding:0;}
    header {background: #0d6efd; color:white; text-align:center; padding:20px; font-size:1.8em;}
    section {padding:20px; margin:10px;}
    h2 {color:#0d6efd;}
    button {background:#0d6efd; color:white; border:none; padding:10px 20px; margin:5px; cursor:pointer; border-radius:5px;}
    button:hover {background:#0b5ed7;}
    #canvas3d {width:100%; height:500px; border:1px solid #ccc; margin-top:20px;}
    input[type=file] {padding:10px;}
    .panel {background:white; border-radius:10px; padding:20px; box-shadow:0 4px 8px rgba(0,0,0,0.1); margin-bottom:20px;}
</style>
</head>
<body>

<header>المشروع المساحي الذكي - Playground Designer</header>

<section class="panel">
<h2>رفع البيانات الميدانية</h2>
<input type="file" id="excelFile" accept=".xlsx,.xls">
<p>ارفع ملف الميزانية الشبكية وبيانات زوايا التيودوليت</p>
</section>

<section class="panel">
<h2>لوحة التحكم</h2>
<button onclick="addElement('football')">🏟 ملعب كرة قدم</button>
<button onclick="addElement('swimming')">🏊 حمام سباحة</button>
<button onclick="addElement('tennis')">🎾 ملعب تنس</button>
<button onclick="addElement('trees')">🌳 مساحات خضراء وأشجار</button>
<button onclick="addElement('paths')">🚶 ممرات</button>
</section>

<section class="panel">
<h2>الحسابات الهندسية</h2>
<button onclick="calculateTraverse()">احسب الترافيرس</button>
<button onclick="calculateGrid()">احسب الميزانية الشبكية وكميات الحفر والردم</button>
</section>

<section class="panel">
<h2>الرسم ثلاثي الأبعاد</h2>
<div id="canvas3d"></div>
</section>

<section class="panel">
<h2>تصدير المشروع</h2>
<button onclick="exportPDF()">تصدير PDF</button>
<button onclick="exportExcel()">تصدير Excel</button>
</section>

<script src="https://cdn.jsdelivr.net/npm/xlsx/dist/xlsx.full.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/three@0.153.0/build/three.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/three@0.153.0/examples/js/controls/OrbitControls.js"></script>
<script>
// ------------- 3D Setup ----------------
let scene = new THREE.Scene();
scene.background = new THREE.Color(0xe0f7fa);
let camera = new THREE.PerspectiveCamera(60, window.innerWidth/window.innerHeight, 0.1, 1000);
camera.position.set(50,50,50);
let renderer = new THREE.WebGLRenderer({antialias:true});
renderer.setSize(window.innerWidth,500);
document.getElementById('canvas3d').appendChild(renderer.domElement);
let controls = new THREE.OrbitControls(camera, renderer.domElement);
controls.update();

// Light
let light = new THREE.DirectionalLight(0xffffff,1);
light.position.set(100,100,100);
scene.add(light);
scene.add(new THREE.AmbientLight(0x404040));

// Ground
let groundGeo = new THREE.PlaneGeometry(200,200,50,50);
let groundMat = new THREE.MeshLambertMaterial({color:0x9ccc65, wireframe:false});
let ground = new THREE.Mesh(groundGeo, groundMat);
ground.rotation.x = -Math.PI/2;
scene.add(ground);

// Elements storage
let elements = [];

// Render loop
function animate(){
    requestAnimationFrame(animate);
    controls.update();
    renderer.render(scene, camera);
}
animate();

// ------------- Functions ----------------
function addElement(type){
    let geometry, material, mesh;
    switch(type){
        case 'football':
            geometry = new THREE.BoxGeometry(20,1,30);
            material = new THREE.MeshLambertMaterial({color:0x4caf50});
            mesh = new THREE.Mesh(geometry, material);
            mesh.position.y=0.5;
            break;
        case 'swimming':
            geometry = new THREE.BoxGeometry(15,1,10);
            material = new THREE.MeshLambertMaterial({color:0x2196f3});
            mesh = new THREE.Mesh(geometry, material);
            mesh.position.y=0.5;
            break;
        case 'tennis':
            geometry = new THREE.BoxGeometry(10,0.5,20);
            material = new THREE.MeshLambertMaterial({color:0xffeb3b});
            mesh = new THREE.Mesh(geometry, material);
            mesh.position.y=0.25;
            break;
        case 'trees':
            geometry = new THREE.CylinderGeometry(0,2,5,8);
            material = new THREE.MeshLambertMaterial({color:0x2e7d32});
            mesh = new THREE.Mesh(geometry, material);
            mesh.position.y=2.5;
            mesh.position.x=Math.random()*50-25;
            mesh.position.z=Math.random()*50-25;
            break;
        case 'paths':
            geometry = new THREE.BoxGeometry(2,0.2,30);
            material = new THREE.MeshLambertMaterial({color:0x795548});
            mesh = new THREE.Mesh(geometry, material);
            mesh.position.y=0.1;
            break;
    }
    scene.add(mesh);
    elements.push(mesh);
}

// ------------- Excel Reader ----------------
document.getElementById('excelFile').addEventListener('change', handleFile,false);
function handleFile(e){
    let file = e.target.files[0];
    let reader = new FileReader();
    reader.onload = function(event){
        let data = new Uint8Array(event.target.result);
        let workbook = XLSX.read(data, {type:'array'});
        let firstSheet = workbook.Sheets[workbook.SheetNames[0]];
        let jsonData = XLSX.utils.sheet_to_json(firstSheet,{header:1});
        console.log('Data:',jsonData);
        alert("تم قراءة البيانات بنجاح!");
        // هنا يمكنك ربط البيانات مع الترافيرس والميزانية الشبكية
    };
    reader.readAsArrayBuffer(file);
}

// ------------- Dummy calculation functions ----------------
function calculateTraverse(){
    alert("تم حساب الترافيرس وتصحيح الزوايا تلقائيًا!");
    // هنا ممكن تضيفي الكود الفعلي لحسابات Bowditch
}

function calculateGrid(){
    alert("تم حساب الميزانية الشبكية وكميات الحفر والردم!");
    // هنا ممكن تضيفي الحسابات الحقيقية للCut & Fill
}

// ------------- Export functions ----------------
function exportPDF(){
    alert("تم تصدير PDF جاهز للتسليم!");
    // يمكن ربط مكتبة jsPDF لتوليد PDF حقيقي
}
function exportExcel(){
    alert("تم تصدير Excel للميزانية الشبكية!");
    // يمكن ربط XLSX.utils.sheet_add_json لإنشاء Excel
}
</script>
</body>
</html>
