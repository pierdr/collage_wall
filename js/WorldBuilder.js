var WorldBuilder = function()
{
  
  //This class creates the SCENE (aka the 3d world)

  //WORLD VARIABLES
  var self = this;
  self.scene = new THREE.Scene();
  self.camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );
  self.renderer = new THREE.WebGLRenderer();
  
  //WEBSOCKETS SERVER
  self.serverUrl = 'ws://localhost:8082'; // Replace with your WebSocket server URL
  self.websocket;
  self.frames = [];
  self.images = [""];

  self.posX = 10;
  //WORLD SETUP
  self.setup = function()
  {
    //CREATE THE RENDERER
    self.renderer.setSize( window.innerWidth, window.innerHeight );
    self.renderer.setClearColor( 0xF7052F, 1 );

    //ADD THE RENDERER TO THE DOCUMENT
    document.body.appendChild( self.renderer.domElement );

    //GENERATE NEW OBJECTES
    for(var i = 0;i<10;i++)
    {
      for(var j = 0; j <10;j++)
      {
        var blockTmp = new Frame();
        blockTmp.init();
        blockTmp.move(i,j,0);
        self.scene.add( blockTmp.mesh );
        self.frames.push(blockTmp);
      }
    }

    self.camera.position.x = 5;
    self.camera.position.y = 5;
    self.camera.position.z = 5;



    ///INIT WEBSOCKET:
   
    self.websocket = new WebSocket(serverUrl);

    self.websocket.onopen = () => {
      console.log('Connected to WebSocket server.');
    };

    self.websocket.onmessage = (event) => {
      const messagesDiv = document.getElementById('messages');
      const message = JSON.parse(event.data);
      messagesDiv.innerHTML += '<p>' + message.content + '</p>';
      console.log(event.data);
    };

    self.websocket.onclose = () => {
      console.log('WebSocket connection closed.');
    };

    self.websocket.onerror = (error) => {
      console.error('WebSocket error:', error);
    };
  }

  //WORLD LOOP
  self.animate = function()
  {

    for(var key in self.frames)
    {
      self.frames[key].rotate(0.01,0,0.01);
    }

    self.renderer.render( self.scene, self.camera );
    //This line assures that animate is called at each Animation Frame
    requestAnimationFrame( self.animate );
  }

  return self;
}
