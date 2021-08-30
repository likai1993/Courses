/*
 *  tiny_http_server.cc
 *
 *  This file is part of TinyHttpServer
 *
 *  TinyHttpServer is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  TinyHttpServer is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with TinyHttpServer; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  US
 *
 *  Author:	Antonino Calderone, <acaldmail@gmail.com>
 *  Author:	Kai Li, <recarelee@gmail.com>
 *  
 *  This work was updated and extended by Kai Li, for the purpose of demostrat *  ing the final project of CSE775 - Distributed Object.
 *
 */

// -----------------------------------------------------------------------------


#include "gen_utils.h"
#include "http_server.h"
#include "socket_utils.h"

#include <iostream>
#include <string>


// -----------------------------------------------------------------------------


class prog_args_t {
private:
    std::string _prog_name;
    std::string _command_line;
    std::string _web_root = HTTP_SERVER_WROOT;
    tcp_socket_t::port_t _http_server_port = HTTP_SERVER_PORT;
    std::string _http_server_addr = HTTP_SERVER_ADDR;
    std::string _http_backend_server_addr = HTTP_SERVER_ADDR;

    bool g_show_help = false;
    bool g_show_ver = false;
    bool g_error = false;
    bool g_verbose_mode = false;
    bool g_redirect_mode = false;
    std::string g_err_msg;

    static const int _min_ver = HTTP_SERVER_MIN_V;
    static const int _maj_ver = HTTP_SERVER_MAJ_V;

public:
    prog_args_t() = delete;


    inline const std::string& get_prog_name() const { return _prog_name; }


    inline const std::string& get_command_line() const { return _command_line; }


    inline const std::string& get_web_root() const { return _web_root; }


    inline tcp_socket_t::port_t get_http_server_port() const
    {
        return _http_server_port;
    }

    inline std::string get_http_server_addr() const
    {
        return _http_server_addr;
    }

    inline std::string get_http_backend_server_addr() const
    {
        return _http_backend_server_addr;
    }
    inline bool is_good() const { return !g_error; }


    inline bool redirect_mode() const { return g_redirect_mode; }


    inline bool verbose_mode() const { return g_verbose_mode; }


    inline const std::string& error() const { return g_err_msg; }


    bool show_info(std::ostream& os) const
    {
        if (g_show_ver)
            std::cout << HTTP_SERVER_NAME << " " << _maj_ver << "." << _min_ver
               << "\n";

        if (!g_show_help)
            return g_show_ver;

        std::cout << "Usage:\n";
        std::cout << "\t" << get_prog_name() << "\n";
        std::cout << "\t\t-a | --addr <ip address>\n";
        std::cout << "\t\t\tBind server to an IP address  (default is "
           << HTTP_SERVER_ADDR << ") \n";
        std::cout << "\t\t-p | --port <port>\n";
        std::cout << "\t\t\tBind server to a TCP port number (default is "
           << HTTP_SERVER_PORT << ") \n";
        std::cout << "\t\t-w | --webroot <working_dir_path>\n";
        std::cout << "\t\t\tSet a local working directory (default is "
           << HTTP_SERVER_WROOT << ") \n";
        std::cout << "\t\t-r | --redirect <ip  address>\n";
        std::cout << "\t\t\tEnable redirect mode (302) (default is " 
	   << HTTP_SERVER_ADDR << ") \n";
        std::cout << "\t\t-vv | --verbstd::coute\n";
        std::cout << "\t\t\tEnable logging on stderr\n";
        std::cout << "\t\t-v | --version\n";
        std::cout << "\t\t\tShow software version\n";
        std::cout << "\t\t-h | --help\n";
        std::cout << "\t\t\tShow this help \n";

        return true;
    }

    /**
     * Parse the command line
     */
    prog_args_t(int argc, char* argv[])
    {
        if (!argc)
            return;

        _prog_name = argv[0];
        _command_line = _prog_name;

        if (argc <= 1)
            return;

        enum class state_t { OPTION, PORT, WEBROOT, ADDR, REDIRECT} state = state_t::OPTION;

        for (int idx = 1; idx < argc; ++idx) {
            std::string sarg = argv[idx];

            _command_line += " ";
            _command_line += sarg;

            switch (state) {
            case state_t::OPTION:
                if (sarg == "--addr" || sarg == "-a") {
                    state = state_t::ADDR;
		} else if (sarg == "--port" || sarg == "-p") {
                    state = state_t::PORT;
                } else if (sarg == "--webroot" || sarg == "-w") {
                    state = state_t::WEBROOT;
                } else if (sarg == "--redirect" || sarg == "-r") {
                    g_redirect_mode = true;
                    state = state_t::REDIRECT;
                } else if (sarg == "--help" || sarg == "-h") {
                    g_show_help = true;
                    state = state_t::OPTION;
                } else if (sarg == "--version" || sarg == "-v") {
                    g_show_ver = true;
                    state = state_t::OPTION;
                } else if (sarg == "--verbose" || sarg == "-vv") {
                    g_verbose_mode = true;
                    state = state_t::OPTION;
                } else {
                    g_err_msg = "Unknown option '" + sarg
                        + "', try with --help or -h";
                    g_error = true;
                    return;
                }
                break;

            case state_t::WEBROOT:
                _web_root = sarg;
                state = state_t::OPTION;
                break;

            case state_t::PORT:
                _http_server_port = std::stoi(sarg);
                state = state_t::OPTION;
                break;
            
            case state_t::ADDR:
                _http_server_addr = sarg;
                state = state_t::OPTION;
                break;
		
            case state_t::REDIRECT:
                _http_backend_server_addr = sarg;
                state = state_t::OPTION;
                break;
            }
        }
    }
};

/**
 * Program entry point
 */

int main(int argc, char* argv[])
{
    std::string msg;

    // Initialize O/S specific libraries
    if (!os_dep::init_lib(msg)) {
        if (!msg.empty())
            std::cerr << msg << std::endl;

        return 1;
    }

    // Parse the command line
    prog_args_t args(argc, argv);

    if (!args.is_good()) {
        std::cerr << args.error() << std::endl;
        return 1;
    }

    if (args.show_info(std::cout)) {
        return 0;
    }

    // invoke get_instance() multiple times to demo the singleton feature  
    http_server_t& httpserver = http_server_t::get_instance();

    httpserver.set_web_root(args.get_web_root());

    if (args.redirect_mode())
    httpserver.set_backend_server(args.get_http_backend_server_addr());

    bool res = httpserver.bind(args.get_http_server_addr(), args.get_http_server_port());

    if (!res) {
        std::cerr << "[Error!] binding IP: " << args.get_http_server_addr() << " port: " << args.get_http_server_port()
                  << "!\n";
        return 1;
    }

    res = httpserver.listen(HTTP_SERVER_BACKLOG);
    if (!res) {
        std::cerr << "[Error!] setting listeing mode!\n";
        return 1;
    }

    std::cout << gen_utils::get_local_time() << std::endl
              //<< "Command line :'" << args.get_command_line() << "'"<< std::endl
              << HTTP_SERVER_NAME << " is listening on port: "
              << args.get_http_server_port() << ", IP:"<< args.get_http_server_addr() << std::endl
              << "Web Root: '" << args.get_web_root() << "'\n" 
	      << "Enable 302 Redirect: "    << (args.redirect_mode()==1?"true":"false") << "\n";

    httpserver.set_logger(args.verbose_mode() ? &std::clog : nullptr);

    if (!httpserver.run()) {
        std::cerr << "[Error!] starting the server!\n";
        return 1;
    }

    return 0;
}
