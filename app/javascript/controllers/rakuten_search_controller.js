import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rakuten-search"
export default class extends Controller {
	static targets = ["keyword"]
  connect() {
  }

	search() {
		const csrfToken = document.getElementsByName('csrf-token')[0].content; // CSRFトークンを取得
		const options = {
			method: "GET", // GETメソッドを指定
			headers: {
				'Accept': 'application/json',
				'Content-Type': 'application/json',
				'X-CSRF-Token': csrfToken // CSRFトークンを設定
			}
		};
		const params = {
			keyword: `インク ${this.keywordTarget.value}`
		};

		const query_params = new URLSearchParams(params);
		const displayResultWrapper = document.getElementById("rakuten-result");

		fetch("/admin/products/search" + "?" + query_params, options)
			.then(results => results.json())
			.then(results => {
				if (results) {
					let resultListHtml = "";

					for (let i in results) {
						//検索結果表示用のHTMLを構築
						resultListHtml += `<li>
																<input type="radio" name="result" value="${results[i]["params"]["productUrlPC"] || results[i]["params"]["itemUrl"]},${results[i]["params"]["mediumImageUrl"] || results[i]["params"]["mediumImageUrls"][0]}" data-action="click->rakuten-search#set">
																<figure>
																	<img src="${results[i]["params"]["mediumImageUrl"] || results[i]["params"]["mediumImageUrls"][0]}" />
																</figure>
																<div>
																	${results[i]["params"]["productName"] || results[i]["params"]["itemName"]}
																</div>
															</li>`;
					}
					// 楽天の検索結果を画面上に表示
					displayResultWrapper.insertAdjacentHTML('beforeend', resultListHtml);
				} else {
					console.error("結果が取得出来ませんでした");
				}
			});
	}

	set(e) {
		const redioButton = e.currentTarget;
		const rakutenData = redioButton.value.split(",");
		const url = document.getElementById("product_productUrl");
		const image = document.getElementById("product_imageUrl");
		url.value = rakutenData[0];
		image.value = rakutenData[1];
	}
}
