export default {
  mounted() {
    const canvas = this.el;
    const ctx = canvas.getContext('2d');
    let width, height;
    
    // Configuration to match CSS:
    // perspective(500px) rotateX(20deg) scale(1.5)
    // transform-origin: top center
    const PERSPECTIVE = 500;
    const ROTATE_X_DEG = 20;
    const ROTATE_X_RAD = ROTATE_X_DEG * (Math.PI / 180);
    const SCALE_BASE = 1.5;
    const GRID_SIZE = 40; // Match CSS background-size
    
    const cos = Math.cos(ROTATE_X_RAD);
    const sin = Math.sin(ROTATE_X_RAD);

    const chars = ['❄', '❅', '❆', '0', '1'];
    const drops = [];

    // Optimization: Pre-render characters to offscreen canvases
    const charCanvases = {};
    const BASE_SIZE = 64; 
    
    chars.forEach(char => {
      const c = document.createElement('canvas');
      c.width = BASE_SIZE;
      c.height = BASE_SIZE;
      const cCtx = c.getContext('2d');
      cCtx.fillStyle = 'rgb(0, 255, 159)';
      cCtx.font = `bold ${BASE_SIZE}px monospace`;
      cCtx.textAlign = 'center';
      cCtx.textBaseline = 'middle';
      cCtx.fillText(char, BASE_SIZE/2, BASE_SIZE/2);
      charCanvases[char] = c;
    });

    class Particle {
        constructor() {
            this.reset(true);
        }
        
        reset(initial = false) {
            const cols = Math.ceil(width / GRID_SIZE);
            const col = Math.floor(Math.random() * cols);
            
            this.gridX = col * GRID_SIZE; 
            
            if (initial) {
                this.y = Math.random() * height;
            } else {
                this.y = -50;
            }
            
            this.char = chars[Math.floor(Math.random() * chars.length)];
            this.speed = 1 + Math.random() * 2;
        }
        
        update() {
            this.y += this.speed;
            
            if (this.y > height * 1.5) { 
                this.reset();
            }
        }
        
        draw() {
            const originX = width / 2;
            const originY = 0; // top
            
            let dx = this.gridX - originX;
            let dy = this.y - originY;
            
            dx *= SCALE_BASE;
            dy *= SCALE_BASE;
            
            const y_rot = dy * cos;
            const z_rot = dy * sin; 
            
            if (z_rot >= PERSPECTIVE - 10) return;
            
            const pScale = PERSPECTIVE / (PERSPECTIVE - z_rot);
            
            // Cap scale to prevent massive overdraw
            if (pScale > 20) return;

            const screenX = originX + dx * pScale;
            const screenY = originY + y_rot * pScale;
            
            const alpha = Math.min(0.8, (z_rot / 200)); 
            if (alpha <= 0.01) return;

            ctx.globalAlpha = alpha;
            
            const size = Math.max(10, 20 * pScale);
            
            ctx.drawImage(
                charCanvases[this.char], 
                screenX - size/2, 
                screenY - size/2, 
                size, 
                size
            );
        }
    }

    const resize = () => {
      width = canvas.width = window.innerWidth;
      height = canvas.height = window.innerHeight;
      drops.length = 0;
      const count = Math.floor(width / 10); 
      for (let i = 0; i < count; i++) {
        drops.push(new Particle());
      }
    };

    window.addEventListener('resize', resize);
    resize();

    const animate = () => {
      ctx.clearRect(0, 0, width, height);
      
      drops.forEach(p => {
          p.update();
          p.draw();
      });

      requestAnimationFrame(animate);
    };

    animate();
  }
};
