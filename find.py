import requests
from bs4 import BeautifulSoup

def read_domains(file_path):
    with open(file_path, 'r') as file:
        domains = [line.strip() for line in file.readlines()]
    return domains

def get_js_links(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an error for bad status codes
        soup = BeautifulSoup(response.text, 'html.parser')
        js_links = [link.get('src') for link in soup.find_all('script') if link.get('src')]
        js_links = [link for link in js_links if link.endswith('.js')]
        return js_links
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {url}: {e}")
        return []

def write_js_links(file_path, links):
    with open(file_path, 'w') as file:
        for link in links:
            file.write(link + '\n')

def main():
    input_file = 'domains.txt'
    output_file = 'found_files.txt'
    
    domains = read_domains(input_file)
    all_js_links = []

    for domain in domains:
        print(f"Processing {domain}")
        js_links = get_js_links(domain)
        all_js_links.extend(js_links)
    
    write_js_links(output_file, all_js_links)
    print(f"JavaScript links saved to {output_file}")

if __name__ == "__main__":
    main()
