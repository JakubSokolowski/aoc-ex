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

    class Particle {
        constructor() {
            this.reset(true);
        }
        
        reset(initial = false) {
            // Pick a random grid line column
            // The CSS grid covers the element width.
            // Element width is 'width' (window width).
            // We want to snap to multiples of GRID_SIZE.
            // Since visible area expands at bottom, we want to cover visible frustum?
            // Actually, we just spawn across the full width. 
            // If they go offscreen at bottom, fine.
            
            const cols = Math.ceil(width / GRID_SIZE);
            const col = Math.floor(Math.random() * cols);
            
            // We use offset to align with the background-grid which starts at 0
            this.gridX = col * GRID_SIZE; 
            
            // Start position along the "floor" (y-axis in element space)
            // 0 is top (far). 'height' is bottom (near).
            // We can spawn them "above" top (negative y) to flow in.
            if (initial) {
                this.y = Math.random() * height;
            } else {
                this.y = -50;
            }
            
            this.char = chars[Math.floor(Math.random() * chars.length)];
            this.speed = 1 + Math.random() * 2; // Slowed down speed
        }
        
        update() {
            this.y += this.speed;
            
            // Reset if it goes too far down/close
            // Visual height check or coordinate check
            // Let's just let it run past height a bit to clear screen
            if (this.y > height * 1.5) { 
                this.reset();
            }
        }
        
        draw() {
            // 3D Projection Math matching CSS
            
            const originX = width / 2;
            const originY = 0; // top
            
            // 1. Offset to center (transform-origin)
            let dx = this.gridX - originX;
            let dy = this.y - originY;
            
            // 2. Scale (scale(1.5))
            dx *= SCALE_BASE;
            dy *= SCALE_BASE;
            
            // 3. Rotate X (20deg)
            // Rotates the plane around the X axis at y=0
            // y (down) -> y' (down projected) and z' (towards viewer)
            const y_rot = dy * cos;
            const z_rot = dy * sin; 
            
            // 4. Perspective (500px)
            // Viewer at z=500. Screen at z=0.
            // Project (x, y_rot, z_rot) onto screen
            // scale = d / (d - z)
            
            // Clip if behind camera or too close
            if (z_rot >= PERSPECTIVE - 10) return;
            
            const pScale = PERSPECTIVE / (PERSPECTIVE - z_rot);
            
            const screenX = originX + dx * pScale;
            const screenY = originY + y_rot * pScale;
            
            // Scaling for size/opacity
            // As it comes closer (pScale increases), it gets bigger
            const size = Math.max(10, 20 * pScale);
            
            // Opacity: Fade in at top, fade out if too close?
            // Actually grid is constant opacity 0.4
            // Let's make particles fade in from distance
            const alpha = Math.min(0.8, (z_rot / 200)); 
            
            ctx.fillStyle = `rgba(0, 255, 159, ${alpha})`;
            ctx.font = `${size}px monospace`;
            ctx.fillText(this.char, screenX, screenY);
        }
    }

    const resize = () => {
      width = canvas.width = window.innerWidth;
      height = canvas.height = window.innerHeight;
      drops.length = 0;
      const count = Math.floor(width / 10); // Increased Density (was / 20)
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
