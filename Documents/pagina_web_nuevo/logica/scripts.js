
        // Carrusel
        const carouselInner = document.getElementById('carouselInner');
        const carouselItems = document.querySelectorAll('.carousel-item');
        const carouselDots = document.querySelectorAll('.carousel-dot');
        const prevBtn = document.querySelector('.carousel-prev');
        const nextBtn = document.querySelector('.carousel-next');
        let currentIndex = 0;
        
        // Función para mostrar slide específico
        function showSlide(index) {
            if (index < 0) {
                index = carouselItems.length - 1;
            } else if (index >= carouselItems.length) {
                index = 0;
            }
            
            currentIndex = index;
            carouselInner.style.transform = `translateX(-${currentIndex * 100}%)`;
            
            // Actualizar dots
            carouselDots.forEach((dot, i) => {
                dot.classList.toggle('active', i === currentIndex);
            });
        }
        
        // Event listeners para controles del carrusel
        prevBtn.addEventListener('click', () => {
            showSlide(currentIndex - 1);
        });
        
        nextBtn.addEventListener('click', () => {
            showSlide(currentIndex + 1);
        });
        
        // Event listeners para los dots
        carouselDots.forEach(dot => {
            dot.addEventListener('click', () => {
                const index = parseInt(dot.getAttribute('data-index'));
                showSlide(index);
            });
        });
        
        // Carrusel automático
        setInterval(() => {
            showSlide(currentIndex + 1);
        }, 5000);