//window.addEventListener('load', function() {
//  // Hide the loader by adding a class that hides it
//  document.getElementById('loader').classList.add('loader-hidden');
//});

<script>
  // Wait for the Flutter app to load completely-->
window.addEventListener('flutter-first-frame', () => {
      const spinner = document.getElementById('loading-spinner');
     if (spinner) {
        spinner.style.display = 'none';
      }
});
</script>