import "chartkick/chart.js"

document.addEventListener('DOMContentLoaded', () => {
    let resizeTO;
  
    window.addEventListener('resize', () => {
      if (resizeTO) clearTimeout(resizeTO);
      resizeTO = setTimeout(() => {
        const event = new Event('resizeEnd');
        window.dispatchEvent(event);
      }, 100);
    });
  });
