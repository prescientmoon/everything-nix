import os

def parse_list_content(list): 
    result = []
    for l in list.splitlines():
        l = l.strip()
        if l == "" or l.startswith("#"): 
            continue
        elif l.startswith("include:"): # We don't currently resolve imports
            continue
        elif l.startswith("full:"):
            l = l.removeprefix("full:")
        l = l.split()[0] # Drop attributes (e.g. "ggpht.cn @cn" -> "ggpht.cn")
        result.append(l)
    return result

domain_list_repo = os.environ['DOMAIN_LIST_REPO']
def include_named(name): 
    with open(f"{domain_list_repo}/data/{name}") as f:
        return parse_list_content(f.read())

youtube = include_named("youtube")
reddit = include_named("reddit")
twitter = include_named("twitter")
misc = [
    "lobste.rs", 
    "news.ycombinator.com",
    "yewtu.be", # Invidious (TODO: add more instances)
]

for domain in sum([youtube, reddit, misc], []):
    print(f"nftset=/{domain}/4#inet#filter#dnsmasq_blocked4")
    print(f"nftset=/{domain}/6#inet#filter#dnsmasq_blocked6")

blocked_mobile = [
    "factorio.com",
    "odin-lang.org",
    "users.rust-lang.org",
    "discourse.haskell.org"
    "discourse.nixos.org", 
    "discourse.purescript.org"
]

for domain in blocked_mobile:
    print(f"nftset=/{domain}/4#inet#filter#dnsmasq_mobile_blocked4")
    print(f"nftset=/{domain}/6#inet#filter#dnsmasq_mobile_blocked6")
