package controller;

import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

/**
 * Servlet implementation class GrapE_SUMRate
 */
@WebServlet("/GrapE_SUNRate")
public class GrapE_SUNRate extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public GrapE_SUNRate() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		
		String countryId = request.getParameter("countryId");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		PrintWriter out = response.getWriter();
		
		if(countryId == "" || countryId == null) {
			out.println("Get country id unsuccessful");
		}else if(startDate == "" || startDate == null) {
			out.println("Get Start date id unsuccessful");
		}else if(endDate == "" || endDate == null) {
			out.println("Get End date id unsuccessful");
		}else {
			try {
				out.println(parser(countryId,startDate,endDate));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	protected String parser(String currency, String startData, String endData) throws Exception {
		
		String gtCurrency = currency;
		String gtCurrencytype = "1";
		String gtRangetype = "3";
		String gtStartdate = startData;
		String gtEnddate = endData;

		final String URL = "https://www.esunbank.com.tw/bank/Layouts/esunbank/Deposit/DpService.aspx/GetLineChartJson";
		HttpURLConnection connection = null;

		try {
			URL url = new URL(URL);
			connection = (HttpURLConnection) url.openConnection();
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod("POST");
			connection.setInstanceFollowRedirects(true);
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestProperty("Referer","https://www.esunbank.com.tw/bank/personal/deposit/rate/forex/exchange-rate-chart");
			connection.connect();

			JSONObject data = new JSONObject();
			data.put("Currency", gtCurrency);
			data.put("Currencytype", gtCurrencytype);
			data.put("Rangetype", gtRangetype);
			data.put("Startdate", gtStartdate);
			data.put("Enddate", gtEnddate);

			JSONObject obj = new JSONObject();
			obj.put("data", data);
						
			OutputStream out = connection.getOutputStream();
			out.write(obj.toString().getBytes());
			out.flush();
			out.close();

			BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			String lines;
			StringBuffer sb = new StringBuffer("");
			while ((lines = reader.readLine()) != null) {
				lines = new String(lines.getBytes(), "utf-8");
				sb.append(lines);
			}
			reader.close();
			connection.disconnect();
			
			//get Rate data
			JSONObject jsonSbObj = new JSONObject(sb.toString());
			JSONObject rateSbObj = new JSONObject(jsonSbObj.getString("d").toString());
			//System.out.println(rateSbObj.getString("Rates"));
						
			return rateSbObj.getString("Rates").toString();

		} catch (MalformedURLException e) {
			e.printStackTrace();
			return "";
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return "";
		} catch (IOException e) {
			e.printStackTrace();
			return "";
		}

	}

}