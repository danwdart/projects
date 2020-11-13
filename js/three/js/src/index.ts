import {
  BoxGeometry,
  DirectionalLight,
  DirectionalLightHelper,
  Mesh,
  MeshBasicMaterial,
  PerspectiveCamera,
  PlaneGeometry,
  Scene,
  WebGLRenderer,
} from "three";

const scene = new Scene();
const camera = new PerspectiveCamera(
  75,
  window.innerWidth / window.innerHeight,
  0.1,
  1000,
);
camera.position.y = 1;
const renderer = new WebGLRenderer();

const cube = new Mesh(
  new BoxGeometry(
    1,
    1,
    1,
  ),
  new MeshBasicMaterial(
    {
      color: 0xff0000,
    },
  ),
);
cube.castShadow = true;
cube.receiveShadow = true;

const plane = new Mesh(
  new PlaneGeometry(
    10,
    10,
  ),
  new MeshBasicMaterial(
    {
      color: 0x0000ff,
    },
  ),
);
plane.position.y = -5;
plane.rotation.x = 1;
plane.receiveShadow = true;

const directionalLight = new DirectionalLight(0xffffff, 0.5);
directionalLight.castShadow = true;
const directionalLightHelper = new DirectionalLightHelper(directionalLight, 5);

const animate = () => {
  cube.rotation.x += 0.01;
  cube.rotation.y += 0.01;
  renderer.render(scene, camera);
  requestAnimationFrame(animate);
};

scene.add(cube);
scene.add(plane);
scene.add(directionalLight);
scene.add(directionalLightHelper);

camera.position.z = 5;

renderer.setSize(window.innerWidth, window.innerHeight);

document.documentElement.appendChild(renderer.domElement);

throw new Error("hi")
animate();