import requests

def read_urls(file_path):
    with open(file_path, 'r') as file:
        urls = [line.strip() for line in file.readlines()]
    return urls

def check_for_polyfill(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an error for bad status codes
        if 'polyfill.io' in response.text:
            return True
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {url}: {e}")
    return False

def main():
    input_file = 'found_files.txt'
    urls = read_urls(input_file)
    
    for url in urls:
        if check_for_polyfill(url):
            print("Found Poly!")
            return
    
    print("Nothing found.")

if __name__ == "__main__":
    main()
