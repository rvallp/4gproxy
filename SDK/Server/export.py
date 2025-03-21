import requests
import json
import csv
from time import sleep

BASE = "http://xxxxxxx:9081"
USERNAME = "admin"
PASSWORD = "admin"
TOKEN = ""

# Proxy configuration (modify these values as needed)
PROXY_CONFIG = {
    #"http": "http://127.0.0.1:1081",    # e.g., "http://192.168.1.1:8080"
    # Add authentication if needed:
    # "http": "http://username:password@proxy_ip:port",
    # "https": "http://username:password@proxy_ip:port",
}

def get_token():
    """Get authentication token using proxy"""
    try:
        r = requests.session()
        # Apply proxy to the session
        r.proxies = PROXY_CONFIG
        
        res = r.post(BASE + "/api/login", data={
            "username": USERNAME,
            "password": PASSWORD
        })
        sb = json.loads(res.text)
        if 'token' in sb:
            return sb['token'], r
        else:
            raise Exception("Login failed, no token received")
    except Exception as e:
        print(f"Failed to get token: {str(e)}")
        return None, None

def get_all_proxies(proxy_type, session, token, page_size=50):
    """Fetch all proxies of specified type using proxy"""
    all_proxies = []
    page = 1
    total = 0
    
    while True:
        try:
            endpoint = f"/token/api/v2/proxy/{proxy_type}?page={page}&size={page_size}"
 
            
            # Session already has proxy configured from get_token()
            result = session.get(BASE + endpoint,
                                headers={
                                    "Content-Type": "application/json",
                                    "XSRF-TOKEN": str(token),
                                })
            
            result.raise_for_status()  # Check HTTP status code
            data = json.loads(result.text)
            
            if not data.get('ok'):
                print(f"Failed to get {proxy_type} proxies: {data.get('msg', 'Unknown error')}")
                break
                
            proxies_data = data.get('data', {})
            proxies_list = proxies_data.get('data', [])
            total = proxies_data.get('total', 0)
            
            all_proxies.extend(proxies_list)
            
            print(f"Fetching {proxy_type} proxies - Page {page}, Got {len(proxies_list)}, Total {len(all_proxies)}/{total}")
            
            if len(all_proxies) >= total:
                break
                
            page += 1
            sleep(1)  # Add delay to avoid overwhelming the server
            
        except Exception as e:
            print(f"Error fetching {proxy_type} proxies: {str(e)}")
            break
            
    return all_proxies

def export_to_csv(proxies, filename):
    """Export proxies to CSV file"""
    if not proxies:
        print(f"No data to export to {filename}")
        return
        
    # Define CSV column names
    fieldnames = [ 'addr', 'authString']
    
    with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        
        for proxy in proxies:
            # Select only needed fields and handle missing values
            row = {field: proxy.get(field, '') for field in fieldnames}
            writer.writerow(row)
    
    print(f"Exported {len(proxies)} records to {filename}")

def main():
    """Main function"""
    # Get token and session
    global TOKEN
    TOKEN, session = get_token()
    if not TOKEN or not session:
        print("Cannot proceed, please check login credentials, proxy settings, and network connection")
        return

    print(f"Got token: {TOKEN}")
    print(f"Using proxy: {PROXY_CONFIG}")
    
    # Fetch all HTTP proxies
    http_proxies = get_all_proxies("http", session, TOKEN)
    # Fetch all Socks5 proxies
    socks5_proxies = get_all_proxies("socks5", session, TOKEN)
    
    # Export to CSV files
    export_to_csv(http_proxies, "http_proxies.csv")
    export_to_csv(socks5_proxies, "socks5_proxies.csv")
    
    # Print statistics
    print("\nExport completed!")
    print(f"Total HTTP proxies: {len(http_proxies)}")
    print(f"Total Socks5 proxies: {len(socks5_proxies)}")
    print(f"Total all proxies: {len(http_proxies) + len(socks5_proxies)}")

if __name__ == "__main__":
    main()