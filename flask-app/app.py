from src import create_app

# Create the app object.
app = create_app()

if __name__ == '__main__':
    # Debug mode for hot reloading.
    app.run(debug = True, host = '0.0.0.0', port = 4000) # Access through our port 8001. 