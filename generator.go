package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"os"
	"strings"
	"time"
)

// Release comes from github
type Release struct {
	Version string
	Assets  []struct {
		URL  string `json:"browser_download_url"`
		Name string `json:"name"`
		Size int64  `json:"size"`
	} `json:"assets"`
}

// OutputAsset show concrete asset info
type OutputAsset struct {
	Arch string `json:"arch"`
	URL  string `json:"url"`
	Size int64  `json:"size"`
}

// Output marks output item with included assets
type Output struct {
	Name        string        `json:"name"`
	Description string        `json:"description"`
	Assets      []OutputAsset `json:"assets"`
}

var timeout = time.Duration(5 * time.Second)

func dialTimeout(network, addr string) (net.Conn, error) {
	return net.DialTimeout(network, addr, timeout)
}

func main() {
	if len(os.Args) <= 1 {
		fmt.Printf("Repo not defined \n")
		os.Exit(1)
	}

	repo := os.Args[1]

	fmt.Printf("Parsing for repo: %#v \n", repo)

	transport := http.Transport{
		Dial: dialTimeout,
	}

	client := http.Client{
		Transport: &transport,
	}

	resp, err := client.Get(fmt.Sprintf("https://api.github.com/repos/%s/releases/latest", repo))
	if err != nil {
		fmt.Printf("Can't get json: %#v \n", err)
		os.Exit(1)
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)

	var release Release
	errJSON := json.Unmarshal(body, &release)
	if errJSON != nil {
		fmt.Printf("Can't parse json: %#v \n", errJSON)
		os.Exit(1)
	}

	output := []Output{}
	osAry := map[string][]OutputAsset{}

	for _, a := range release.Assets {
		osName := "Universal"
		arch := ""

		parts := strings.Split(a.Name, ".")
		fmt.Printf("Parts: %#v", parts)
		subParts := strings.Split(parts[len(parts)-2], "_")

		if strings.Contains(a.Name, "client") {
			osName = "Client"
		} else if len(subParts) == 2 {
			// Universal
			osName = strings.Title(subParts[0])
			arch = subParts[1]
		}

		if osName == "Darwin" {
			osName = "OSx"
		} else if osName == "Ios" {
			osName = "iOS"
		}

		if _, ok := osAry[osName]; !ok {
			osAry[osName] = []OutputAsset{}
		}

		arch = strings.Replace(arch, "-", "", -1)
		osAry[osName] = append(osAry[osName], OutputAsset{arch, a.URL, a.Size})
	}

	output = append(output, Output{
		Name:   "Universal",
		Assets: osAry["Universal"],
	})
	delete(osAry, "Universal")

	if _, ok := osAry["Client"]; ok {
		output = append(output, Output{
			Name:   "Client",
			Assets: osAry["Client"],
		})
		delete(osAry, "Client")
	}

	for i, v := range osAry {
		output = append(output, Output{
			Name:   i,
			Assets: v,
		})
	}

	fmt.Printf("Output: %#v \n", output)

	repoParts := strings.Split(repo, "/")
	outputJSON, _ := json.Marshal(output)
	errWrite := ioutil.WriteFile(fmt.Sprintf("src/data/%s/platforms.json", repoParts[1]), outputJSON, 0644)
	if errWrite != nil {
		fmt.Printf("Can't write json: %#v \n", errWrite)
		os.Exit(1)
	}
}
